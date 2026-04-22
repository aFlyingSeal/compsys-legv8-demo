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

    // nếu n < 0 thì n ko là số chính phương
    cmp         x19, #0
    b.lt        is_not_square

    mov         x20, #0     // i = 0 

loop:
    mul         x21, x20, x20       // x21 = i * i

    cmp         x21, x19            // so sánh i * i với n
    b.eq        is_square       // nếu bằng thì n là số chính phương
    b.gt        is_not_square       // nếu i * i > n thì n ko là số chính phương

    add         x20, x20, #1        // i++
    b           loop

is_square:
    // in thông báo là số chính phương
    adrp        x0, tb_yes
    add         x0, x0, :lo12:tb_yes
    bl          printf
    b           exit

is_not_square:
    // in thông báo không là số chính phương
    adrp        x0, tb_no
    add         x0, x0, :lo12:tb_no
    bl          printf

exit:
    mov         x0, #0
    mov         x8, #93
    svc         #0
