section .data
    prompt db "Nhap n: ", 0
    len_p equ $ - prompt
    msg_yes db "YES", 0xA
    len_y equ $ - msg_yes
    msg_no db "NO", 0xA
    len_n equ $ - msg_no

section .bss
    buffer resb 10
    n resd 1
    sum resd 1 

section .text
    global _start

_start:
    ; in thông báo nhập
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, len_p
    int 0x80

    ; đọc dữ liệu 
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 10
    int 0x80

    ; chuyển ASCII sang int 
    mov esi, buffer
    xor eax, eax
    xor ebx, ebx
.convert:
    mov bl, [esi]
    cmp bl, 10          ; Xuong dong
    je .done_convert
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .convert
.done_convert:
    mov [n], eax

    ; kiểm tra số hoàn thiện 
    cmp eax, 1          ; n <= 1 ko là số hoàn thiện
    jle .is_not_perfect

    mov dword [sum], 0  ; sum = 0
    mov ecx, 1          ; i = 1

.loop_div:
    mov eax, ecx
    cmp eax, [n]        ; nếu i >= n thì dừng 
    jge .check_result

    ; kiểm tra n chia hết cho i
    mov eax, [n]
    xor edx, edx        ; xóa edx để chia
    div ecx             ; n / i
    cmp edx, 0          ; nếu dư == 0 thì i là ước 
    jne .next_i

    ; cộng dồn vào tổng các ước
    add [sum], ecx

.next_i:
    inc ecx
    jmp .loop_div

.check_result:
    mov eax, [sum]
    cmp eax, [n]        ; so sánh với tổng các ước của n
    je .is_perfect

.is_not_perfect:
    mov ecx, msg_no
    mov edx, len_n
    jmp .print

.is_perfect:
    mov ecx, msg_yes
    mov edx, len_y

.print:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
