section .data
    menu_msg db 10, "--- MENU ---", 10, \
                "1. Nhap mang", 10, \
                "2. Xuat mang", 10, \
                "3. Liet ke so nguyen to", 10, \
                "4. Tim Max", 10, \
                "5. Tinh TBC (lam tron xuong)", 10, \
                "0. Thoat", 10, "Chon: ", 0
    prompt_n    db "Nhap n: ", 0
    prompt_ele  db "Nhap phan tu: ", 0
    msg_max     db "Gia tri lon nhat: ", 0
    msg_tbc     db "Trung binh cong: ", 0
    msg_prime   db "Cac so nguyen to: ", 0
    space       db " ", 0
    newline     db 10, 0

section .bss
    n       resd 1
    array   resd 100    ; Mang chua toi da 100 so nguyen (400 bytes)
    buffer  resb 16     ; Bo nho tam de nhap/xuat
    choice  resb 2

section .text
    global _start

_start:
main_menu:
    ; in menu 
    mov eax, menu_msg
    call print_string

    ; nhập lựa chọn
    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 2
    int 0x80

    movzx eax, byte [choice]
    sub eax, '0'

    cmp eax, 1
    je call_nhap
    cmp eax, 2
    je call_xuat
    cmp eax, 3
    je call_prime
    cmp eax, 4
    je call_max
    cmp eax, 5
    je call_tbc
    cmp eax, 0
    je exit_program
    jmp main_menu

call_nhap:
    call input_array
    jmp main_menu
call_xuat:
    call output_array
    jmp main_menu
call_prime:
    call list_primes
    jmp main_menu
call_max:
    call find_max
    jmp main_menu
call_tbc:
    call calc_avg
    jmp main_menu

; hàm nhập mảng
input_array:
    mov eax, prompt_n
    call print_string
    call read_int
    mov [n], eax

    xor edi, edi        ; i = 0
.loop_input:
    cmp edi, [n]
    jge .done
    mov eax, prompt_ele
    call print_string
    call read_int
    mov [array + edi*4], eax
    inc edi
    jmp .loop_input
.done:
    ret

; hàm xuất mảng 
output_array:
    xor edi, edi
.loop_output:
    cmp edi, [n]
    jge .done
    mov eax, [array + edi*4]
    call print_int
    mov eax, space
    call print_string
    inc edi
    jmp .loop_output
.done:
    mov eax, newline
    call print_string
    ret

; liệt kê số nguyên tố
list_primes:
    mov eax, msg_prime
    call print_string
    xor edi, edi
.loop_p:
    cmp edi, [n]
    jge .done
    mov eax, [array + edi*4]
    call check_prime    ; hàm trả về bl = 1 nếu là SNT
    cmp bl, 1
    jne .next
    mov eax, [array + edi*4]
    call print_int
    mov eax, space
    call print_string
.next:
    inc edi
    jmp .loop_p
.done:
    ret

; tìm giá trị lớn nhất
find_max:
    mov eax, [array]
    mov ebx, eax        ; max = ebx
    mov ecx, 1          ; i = 1
.loop_max:
    cmp ecx, [n]
    jge .done
    mov edx, [array + ecx*4]
    cmp edx, ebx
    jle .next
    mov ebx, edx
.next:
    inc ecx
    jmp .loop_max
.done:
    mov eax, msg_max
    call print_string
    mov eax, ebx
    call print_int
    ret

; tính trung bình cộng
calc_avg:
    xor eax, eax        ; sum = eax 
    xor ecx, ecx        ; i = 0
.loop_sum:
    cmp ecx, [n]
    jge .div_avg
    add eax, [array + ecx*4]
    inc ecx
    jmp .loop_sum
.div_avg:
    xor edx, edx
    mov ecx, [n]
    div ecx             ; eax = sum / n
    push eax
    mov eax, msg_tbc
    call print_string
    pop eax
    call print_int
    ret

; hàm hỗ trợ

; kiểm tra SNT (eax), trả về bl = 1 hoặc 0 
check_prime:
    cmp eax, 2
    jl .not_p
    mov esi, eax
    mov ecx, 2
.lp:
    mov edx, 0
    mov eax, esi
    div ecx
    cmp edx, 0
    je .check_equal
    inc ecx
    jmp .lp
.check_equal:
    cmp ecx, esi
    je .is_p
.not_p:
    mov bl, 0
    ret
.is_p:
    mov bl, 1
    ret

; nhập số nguyên từ bàn phím (chuyển từ ASCII sang int)
read_int:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 16
    int 0x80
    xor eax, eax
    mov esi, buffer
.convert:
    movzx ebx, byte [esi]
    cmp bl, 10
    je .done
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .convert
.done:
    ret

; in số nguyên (chuyển từ int sang ASCII)
print_int:
    mov ecx, 10
    mov esi, buffer + 15
    mov byte [esi], 0
.lp:
    xor edx, edx
    div ecx
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .lp
    mov eax, esi
    call print_string
    ret

; in chuỗi (eax = địa chỉ chuỗi)
print_string:
    push eax
    xor edx, edx
.count:
    cmp byte [eax + edx], 0
    je .out
    inc edx
    jmp .count
.out:
    mov ecx, eax
    mov eax, 4
    mov ebx, 1
    int 0x80
    pop eax
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
