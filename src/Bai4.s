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
    bl          printf

    // nhập n
    adrp        x0, fmt
    add         x0, x0, :lo12:fmt
    adrp        x1, n 
    add         x1, x1, :lo12:n 
    bl          scanf

    // nạp n vào x19
    adrp        x19, n
    add         x19, x19, :lo12:n
    ldur        x19, [x19]

    // số âm chứa dấu trừ thì ko tính trong tính đối xứng
    // nếu n < 0 thì n = n * (-1)
    cmp         x19, #0
    b.ge        start
    neg         x19, x19

start:
    mov         x20, x19        // tmp = n (biến tạm để tách chữ số)
    mov         x21, #0         // rev = 0 (lưu số đảo ngược)
    mov         x24, #10        // hằng số = 10 để chia lấy chữ số cuối

loop_reverse:
    cmp         x20, #0         // tmp = 0 => đảo ngược chữ số xong
    b.eq        check

    // lấy chữ số cuối
    udiv        x22, x20, x24           // q = tmp / 10
    msub        x23, x22, x24, x20      // r = tmp - (q * 10)

    // xây dựng rev
    mul         x21, x21, x24   // rev = rev * 10
    add         x21, x21, x23   // rev = rev + r

    mov         x20, x22        // tmp = tmp / 10 
    b           loop_reverse

check:
    cmp         x21, x19        // so sánh rev với n 
    b.eq        is_palindrome

is_not_palindrome:
    // in thông báo không là số đối xứng
    adrp        x0, tb_no
    add         x0, x0, :lo12:tb_no
    bl          printf
    b           exit

is_palindrome:
    // in thông báo là số đối xứng
    adrp        x0, tb_yes
    add         x0, x0, :lo12:tb_yes
    bl          printf

exit:
    mov         x0, #0
    mov         x8, #93
    svc         #0
