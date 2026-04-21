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
    adrp        x0, tb_nhap
    add         x0, x0, :lo12:tb_nhap
    bl printf

    adrp        x0, fmt
    add         x0, x0, :lo12:fmt
    adrp        x1, n
    add         x1, x1, :lo12:n
    bl scanf

    adrp        x19, n 
    add         x19, x19, :lo12:n 
    ldur        x19, [x19]

    cmp         x19, #2 
    b.lt        is_not_prime
    b.eq        is_prime 

    mov         x20, #2

loop:
    mul         x21, x20, x20
    cmp         x21, x19 
    b.gt        is_prime 

    udiv        x22, x19, x20
    msub        x23, x22, x20, x19
    cmp         x23, #0
    b.eq        is_not_prime
    add         x20, x20, #1

    b           loop

is_prime:
    adrp        x0, tb_yes
    add         x0, x0, :lo12:tb_yes
    bl          printf
    b           exit

is_not_prime:
    adrp        x0, tb_no
    add         x0, x0, :lo12:tb_no
    bl          printf

exit:
    mov         x0, #0
    mov         x8, #93
    svc         #0
