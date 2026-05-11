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

    // nếu n <= 1 thì n ko là số hoàn thiện
    cmp         x19, #1
    b.le        is_not_perfect

    mov         x20, #1     // i = 1
    mov         x21, #0     // tổng các ước: sum = 0

loop:
    // điều kiện dừng: i >= n 
    cmp         x20, x19
    b.ge        check

    // kiểm tra n % i == 0
    udiv        x22, x19, x20           // q = n / i
    msub        x23, x22, x20, x19      // r = n - q * i

    // nếu i không là ước thì tiếp tục
    cmp         x23, #0
    b.ne        increment

    // nếu i là ước của n thì sum += i
    add         x21, x21, x20

increment:
    add         x20, x20, #1    // i++
    b           loop

check:
    // so sánh tổng các ước với n
    cmp         x21, x19
    b.eq        is_perfect

is_not_perfect:
    // in thông báo không là số hoàn thiện
    adrp        x0, tb_no
    add         x0, x0, :lo12:tb_no
    bl          printf
    b           exit

is_perfect:
    // in thông báo không là hoàn thiện
    adrp        x0, tb_yes
    add         x0, x0, :lo12:tb_yes
    bl printf

exit:
    mov         x0, #0
    mov         x8, #93
    svc         #0
