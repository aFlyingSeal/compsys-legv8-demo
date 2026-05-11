section .data
    prompt db "Nhap n: ", 0
    len_p equ $ - prompt
    msg_yes db "YES", 0xA
    len_y equ $ - msg_yes
    msg_no db "NO", 0xA
    len_n equ $ - msg_no

section .bss
    buffer resb 12
    n_orig resd 1 
    n_temp resd 1 
    n_rev  resd 1 

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
    mov edx, 12
    int 0x80

    ; chuyển ASCII sang int
    mov esi, buffer
    xor eax, eax
    xor ebx, ebx
.convert:
    mov bl, [esi]
    cmp bl, 10          ; kiểm tra ký tự xuống dòng
    je .done_convert
    cmp bl, '0'
    jb .done_convert 
    cmp bl, '9'
    ja .done_convert
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .convert
.done_convert:
    mov [n_orig], eax   ; lưu n gốc để so sánh
    mov [n_temp], eax   ; n tạm để xây dựng số nghịch đảo
    mov dword [n_rev], 0 ; số đảo ngược = 0

.reverse_loop:
    mov eax, [n_temp]
    cmp eax, 0
    je .compare         ; n tạm = 0 -> n gốc hết chữ số -> đảo ngược xong 

    ; Lay chu so cuoi (n_temp % 10)
    xor edx, edx
    mov ecx, 10
    div ecx             ; eax = n_temp / 10, edx = n_temp % 10
    mov [n_temp], eax   ; cập nhật lại n tạm
    
    mov ebx, edx        ; lưu số dư vào ebx 

    ; n_rev = (n_rev * 10) + digit
    mov eax, [n_rev]
    imul eax, 10
    add eax, ebx
    mov [n_rev], eax
    
    jmp .reverse_loop

    ; so sánh số gốc với số nghịch đảo 
.compare:
    mov eax, [n_orig]
    cmp eax, [n_rev]
    je .is_palindrome

.is_not_palindrome:
    mov ecx, msg_no
    mov edx, len_n
    jmp .print

.is_palindrome:
    mov ecx, msg_yes
    mov edx, len_y

.print:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
