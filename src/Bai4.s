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
    bl          printf

    adrp        x0, fmt
    add         x0, x0, :lo12:fmt
    adrp        x1, n 
    add         x1, x1, :lo12:n 
    bl          scanf

    adrp        x19, n
    add         x19, x19, :lo12:n
    ldur        x19, [x19]

    cmp         x19, #0
    b.ge        start
    neg         x19, x19

start:
    mov         x20, x19
    mov         x21, #0
    mov         x24, #10

loop_reverse:
    cmp         x20, #0
    b.eq        check

    udiv        x22, x20, x24
    msub        x23, x22, x24, x20

    mul         x21, x21, x24
    add         x21, x21, x23

    mov         x20, x22
    b           loop_reverse

check:
    cmp         x21, x19
    b.eq        is_palindrome

is_not_palindrome:
    adrp        x0, tb_no
    add         x0, x0, :lo12:tb_no
    bl          printf
    b           exit

is_palindrome:
    adrp        x0, tb_yes
    add         x0, x0, :lo12:tb_yes
    bl          printf

exit:
    mov         x0, #0
    mov         x8, #93
    svc         #0
