section .data
    prompt db "Nhap n: ", 0
    len_p equ $ - prompt
    yes_msg db "YES", 0xA
    len_y equ $ - yes_msg
    no_msg db "NO", 0xA
    len_n equ $ - no_msg

section .bss
    num resb 10          
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

    ; đọc dữ liệu từ bàn phím
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 10
    int 0x80

    ; chuyển chuỗi thành số nguyên (ASCII to Integer)
    mov esi, num
    xor eax, eax        ; eax sẽ lưu giá trị số n
    xor ebx, ebx        ; ebx dùng làm thanh ghi tạm
.convert:
    mov bl, [esi]
    cmp bl, 10          ; kiểm tra ký tự xuống dòng (Line feed)
    je .done_convert
    sub bl, '0'         ; chuyển ASCII sang số
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .convert
.done_convert:
    mov [n], eax

    ; kiểm tra số nguyên tố
    mov eax, [n]
    cmp eax, 2
    jl .is_not_prime    ; n < 2 không phải số nguyên tố
    je .is_prime        ; n = 2 là số nguyên tố

    ; kiểm tra vòng lặp từ 2 đến n-1
    mov ecx, 2          ; ecx là ước số thử nghiệm (divisor)
.loop_check:
    mov eax, ecx
    mul eax             ; eax = ecx * ecx
    cmp eax, [n]        ; kiểm tra điều kiện dừng: ecx * ecx > n
    jg .is_prime

    mov eax, [n]
    xor edx, edx        ; xóa edx trước khi chia (để lưu số dư)
    div ecx             ; eax / ecx, số dư nằm ở edx
    cmp edx, 0          ; nếu dư 0 thì không phải số nguyên tố
    je .is_not_prime
    
    inc ecx
    jmp .loop_check

.is_prime:
    mov ecx, yes_msg
    mov edx, len_y
    jmp .print_result

.is_not_prime:
    mov ecx, no_msg
    mov edx, len_n

.print_result:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
