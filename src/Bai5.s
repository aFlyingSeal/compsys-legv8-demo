.extern printf
.extern scanf
.extern fflush

.section .data
    tb1:        .asciz "Nhap n: "
    tb2:        .asciz "a[%ld]: "
    tb3:        .asciz "Mang vua nhap: "
    tb_snt:     .asciz "Cac so nguyen to trong mang: "
    tb_max:     .asciz "\nGia tri lon nhat: %ld\n"
    tb_tbc:     .asciz "Trung binh cong: %ld\n"
    fmt1:       .asciz "%ld"
    fmt2:       .asciz "%ld "
    endl:       .asciz "\n"

.section .bss
    n:          .space 8
    arr:        .space 800

.section .text
.global main

check_prime:
    cmp         x0, #2
    b.lt        not_prime
    b.eq        is_prime
    mov         x1, #2
loop_check_prime:
    mul         x2, x1, x1
    cmp         x2, x0
    b.gt        is_prime

    udiv        x3, x0, x1
    msub        x4, x3, x1, x0

    cmp         x4, #0
    b.eq        not_prime
    
    add         x1, x1, #1
    b           loop_check_prime
is_prime:
    mov         x0, #1
    br          lr
not_prime:
    mov         x0, #0
    br          lr

main:
    adrp        x0, tb1
    add         x0, x0, :lo12:tb1
    bl          printf

    adrp        x0, fmt1
    add         x0, x0, :lo12:fmt1
    adrp        x1, n 
    add         x1, x1, :lo12:n 
    bl          scanf

    adrp        x19, n
    add         x19, x19, :lo12:n 
    ldur        x19, [x19]

    adrp        x20, arr
    add         x20, x20, :lo12:arr

    mov         x21, #0

loop_input:
    cmp         x21, x19
    b.ge        print_msg_out

    adrp        x0, tb2
    add         x0, x0, :lo12:tb2
    mov         x1, x21
    bl          printf

    adrp        x0, fmt1
    add         x0, x0, :lo12:fmt1
    mov         x1, x20
    bl          scanf

    add         x20, x20, #8
    add         x21, x21, #1
    b           loop_input

print_msg_out:
    adrp        x0, tb3
    add         x0, x0, :lo12:tb3
    bl          printf
    adrp        x20, arr
    add         x20, x20, :lo12:arr
    mov         x21, #0

loop_output:
    cmp         x21, x19
    b.ge        start_prime_check

    adrp        x0, fmt2
    add         x0, x0, :lo12:fmt2
    ldur        x1, [x20]
    bl          printf

    add         x20, x20, #8
    add         x21, x21, #1
    b           loop_output

start_prime_check:
    adrp        x0, endl
    add         x0, x0, :lo12:endl
    bl          printf

    adrp        x0, tb_snt
    add         x0, x0, :lo12:tb_snt
    bl          printf

    adrp        x20, arr
    add         x20, x20, :lo12:arr
    mov         x21, #0
loop_prime_check:
    cmp         x21, x19
    b.ge        start_max_avg

    ldur        x22, [x20]
    mov         x0, x22
    bl          check_prime

    cmp         x0, #1
    b.ne        next_prime
    
    adrp        x0, fmt2
    add         x0, x0, :lo12:fmt2
    mov         x1, x22
    bl          printf
next_prime:
    add         x20, x20, #8
    add         x21, x21, #1
    b           loop_prime_check

start_max_avg:
    adrp        x20, arr
    add         x20, x20, :lo12:arr
    ldur        x22, [x20]
    mov         x21, #0
    mov         x23, #0
loop_calculate:
    cmp         x21, x19
    b.ge        finish

    ldur        x24, [x20]
    add         x23, x23, x24
    
    cmp         x24, x22
    b.le        not_max
    mov         x22, x24
not_max:
    add         x20, x20, #8
    add         x21, x21, #1
    b           loop_calculate

finish:
    adrp        x0, tb_max
    add         x0, x0, :lo12:tb_max
    mov         x1, x22
    bl          printf

    sdiv        x1, x23, x19
    adrp        x0, tb_tbc
    add         x0, x0, :lo12:tb_tbc
    bl          printf

exit:
    ldp         x29, x30, [sp], 16
    mov         x0, #0
    mov         x8, #93
    svc         #0
