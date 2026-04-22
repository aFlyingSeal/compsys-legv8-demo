.extern printf
.extern scanf

.section .data
    tb_nhap:    .asciz "Nhap n: "
    fmt:        .asciz "%ld"
    tb_yes:     .asciz "YES\n"
    tb_no:      .asciz "NO\n"

.section .bss
    n:          .space 8

.section .text
.global main
main:
    // in thông báo nhập n
    adrp        x0, tb_nhap
    add         x0, x0, :lo12:tb_nhap
    bl printf

    // nhập n
    adrp        x0, fmt
    add         x0, x0, :lo12:fmt
    adrp        x1, n
    add         x1, x1, :lo12:n
    bl scanf

    // nạp n vào x19
    adrp        x19, n 
    add         x19, x19, :lo12:n 
    ldur        x19, [x19]

    // nếu n < 2 thì n ko là số nguyên tố
    cmp         x19, #2 
    b.lt        is_not_prime
    // n = 2 là số nguyên tố
    b.eq        is_prime    

    mov         x20, #2         // i = 2

loop:
    mul         x21, x20, x20   // x21 = i * i

    // điều kiện dừng: i * i > n
    // nếu i * i > n mà chưa chia hết cho số nào thì n là số nguyên tố
    cmp         x21, x19 
    b.gt        is_prime

    // kiểm tra n % i == 0
    udiv        x22, x19, x20           // q = n / i
    msub        x23, x22, x20, x19      // r = n - (q * i)

    // nếu n % i == 0 (r == 0) thì n ko là số nguyên tố
    cmp         x23, #0
    b.eq        is_not_prime

    add         x20, x20, #1    // i++
    b           loop

is_prime:
    // in thông báo là số nguyên tố
    adrp        x0, tb_yes
    add         x0, x0, :lo12:tb_yes
    bl          printf
    b           exit

is_not_prime:
    // in thông báo không là số nguyên tố
    adrp        x0, tb_no
    add         x0, x0, :lo12:tb_no
    bl          printf

exit:
    mov         x0, #0
    mov         x8, #93
    svc         #0
