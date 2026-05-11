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
    cmp bl, 10          ; kiểm tra ký tự xuống dòng
    je .done_convert
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .convert
.done_convert:
    mov [n], eax

    ; kiểm tra số chính phương
    xor ecx, ecx        ; i = 0
.loop_check:
    mov eax, ecx
    mul eax             ; eax = ecx * ecx (i * i)
    
    cmp eax, [n]        ; so sánh i^2 với n
    je .is_square       ; nếu i^2 == n thì dừng
    jg .is_not_square   ; nếu i^2 > n thì n không phải số chính phương

    inc ecx             ; i++
    jmp .loop_check

.is_square:
    mov ecx, msg_yes
    mov edx, len_y
    jmp .print

.is_not_square:
    mov ecx, msg_no
    mov edx, len_n

.print:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
