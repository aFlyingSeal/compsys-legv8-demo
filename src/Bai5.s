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

_InputArray:
    sub         sp, sp, #32
    stur        x30, [sp, #24]
    stur        x19, [sp, #16]
    stur        x20, [sp, #8]
    stur        x21, [sp, #0]

    mov         x19, x0
    mov         x20, x1
    mov         x21, #0
_InputArray.loop:
    cmp         x21, x20
    b.ge        _InputArray.exit

    adrp        x0, tb2
    add         x0, x0, :lo12:tb2
    mov         x1, x21
    bl          printf

    adrp        x0, fmt1
    add         x0, x0, :lo12:fmt1
    lsl         x22, x21, #3
    add         x1, x19, x22
    bl          scanf

    add         x21, x21, #1
    b           _InputArray.loop
_InputArray.exit:
    ldur        x21, [sp, #0]
    ldur        x20, [sp, #8]
    ldur        x19, [sp, #16]
    ldur        x30, [sp, #24]
    add         sp, sp, #32
    br          lr

_OutputArray:
    sub         sp, sp, #32
    stur        x30, [sp, #24]
    stur        x19, [sp, #16]
    stur        x20, [sp, #8]
    stur        x21, [sp, #0]

    mov         x19, x0
    mov         x20, x1
    mov         x21, #0
_OutputArray.loop:
    cmp         x21, x20
    b.ge        _OutputArray.exit

    adrp        x0, fmt2
    add         x0, x0, :lo12:fmt2
    lsl         x22, x21, #3
    add         x23, x19, x22
    ldur        x1, [x23, #0]
    bl          printf

    add         x21, x21, #1
    b           _OutputArray.loop
_OutputArray.exit:
    ldur        x21, [sp, #0]
    ldur        x20, [sp, #8]
    ldur        x19, [sp, #16]
    ldur        x30, [sp, #24]
    add         sp, sp, #32
    br          lr

_PrimeCheck:
    sub         sp, sp, #16
    stur        x30, [sp, #8]
    stur        x1, [sp, #0]

    cmp         x0, #2
    b.lt        _PrimeCheck.not_prime
    b.eq        _PrimeCheck.is_prime
    mov         x1, #2
_PrimeCheck.loop:
    mul         x2, x1, x1
    cmp         x2, x0
    b.gt        _PrimeCheck.is_prime

    udiv        x3, x0, x1
    msub        x4, x3, x1, x0
    
    cmp         x4, #0
    b.eq        _PrimeCheck.not_prime

    add         x1, x1, #1
    b           _PrimeCheck.loop
_PrimeCheck.is_prime:
    mov         x0, #1
    b           _PrimeCheck.exit
_PrimeCheck.not_prime:
    mov         x0, #0
_PrimeCheck.exit:
    ldur        x1, [sp, #0]
    ldur        x30, [sp, #8]
    add         sp, sp, #16
    br          lr

_FindMax:
    sub         sp, sp, #48         // Backup nhiều hơn để bảo vệ x19-x23
    stur        x30, [sp, #40]
    stur        x19, [sp, #32]
    stur        x20, [sp, #24]
    stur        x21, [sp, #16]
    stur        x22, [sp, #8]
    stur        x23, [sp, #0]

    mov         x19, x0
    ldur        x0, [x19, #0]       // Max = a[0]
    mov         x20, #0
_FindMax.loop:
    cmp         x20, x1
    b.ge        _FindMax.exit

    lsl         x21, x20, #3
    add         x22, x19, x21
    ldur        x23, [x22, #0]

    cmp         x23, x0
    b.le        _FindMax.next

    mov         x0, x23
_FindMax.next:
    add         x20, x20, #1
    b           _FindMax.loop
_FindMax.exit:
    ldur        x23, [sp, #0]
    ldur        x22, [sp, #8]
    ldur        x21, [sp, #16]
    ldur        x20, [sp, #24]
    ldur        x19, [sp, #32]
    ldur        x30, [sp, #40]
    add         sp, sp, #48
    br          lr

main:
    sub         sp, sp, #16
    stur        x30, [sp, #8]

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

    adrp        x0, arr
    add         x0, x0, :lo12:arr
    mov         x1, x19
    bl          _InputArray

    adrp        x0, tb3
    add         x0, x0, :lo12:tb3
    bl          printf

    adrp        x0, arr
    add         x0, x0, :lo12:arr
    mov         x1, x19
    bl          _OutputArray

    adrp        x0, endl
    add         x0, x0, :lo12:endl
    bl          printf

    adrp        x0, tb_snt
    add         x0, x0, :lo12:tb_snt
    bl          printf

    mov         x20, #0
    mov         x21, #0
main.loop:
    cmp         x20, x19
    b.ge        print_max_avg

    adrp        x22, arr
    add         x22, x22, :lo12:arr
    lsl         x23, x20, #3
    add         x24, x22, x23
    ldur        x25, [x24, #0]

    add         x21, x21, x25

    mov         x0, x25
    bl          _PrimeCheck
    
    cmp         x0, #1
    b.ne        main.next

    adrp        x0, fmt2
    add         x0, x0, :lo12:fmt2
    mov         x1, x25
    bl          printf
main.next:
    add         x20, x20, #1
    b           main.loop

print_max_avg:
    adrp        x0, arr
    add         x0, x0, :lo12:arr
    mov         x1, x19
    bl          _FindMax

    mov         x22, x0
    adrp        x0, tb_max
    add         x0, x0, :lo12:tb_max
    mov         x1, x22
    bl          printf

    sdiv        x1, x21, x19
    adrp        x0, tb_tbc
    add         x0, x0, :lo12:tb_tbc
    bl          printf

exit:
    ldur        x30, [sp, #8]
    add         sp, sp, #16
    mov         x0, #0
    mov         x8, #93
    svc         #0
