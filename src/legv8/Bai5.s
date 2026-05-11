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

// thủ tục 1: nhập mảng
// input: x0 (địa chỉ mảng), x1 (kích thước n)
_InputArray:
    sub         sp, sp, #32
    stur        x30, [sp, #24]
    stur        x19, [sp, #16]      // lưu địa chỉ mảng
    stur        x20, [sp, #8]       // lưu n
    stur        x21, [sp, #0]       // i

    mov         x19, x0
    mov         x20, x1
    mov         x21, #0             // i = 0
_InputArray.loop:
    // lặp từ 0 -> n - 1
    cmp         x21, x20
    b.ge        _InputArray.exit

    // in thông báo nhập a[i]
    adrp        x0, tb2
    add         x0, x0, :lo12:tb2
    mov         x1, x21
    bl          printf

    // nhập a[i]
    adrp        x0, fmt1
    add         x0, x0, :lo12:fmt1
    lsl         x22, x21, #3        // offset = i * 8
    add         x1, x19, x22        // x1 = &arr[i]
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

// thủ tục 2: xuất mảng
// input: x0 (địa chỉ mảng), x1 (kích thước n)
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
    // lặp từ 0 -> n - 1
    cmp         x21, x20
    b.ge        _OutputArray.exit

    // in ra phần tử a[i]
    adrp        x0, fmt2
    add         x0, x0, :lo12:fmt2
    lsl         x22, x21, #3        // tính địa chỉ a[i]
    add         x23, x19, x22       // nạp địa chỉ a[i] vào x1 để in
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

// thủ tục 3: kiểm tra số nguyên tố
// input: x0 (giá trị n)
// output: x0 (1: đúng, 0: sai)
_PrimeCheck:
    sub         sp, sp, #16
    stur        x30, [sp, #8]
    stur        x1, [sp, #0]

    // nếu n < 2 thì n ko là số nguyên tố
    cmp         x0, #2
    b.lt        _PrimeCheck.not_prime

    // n == 2 là số nguyên tố
    b.eq        _PrimeCheck.is_prime

    mov         x1, #2      // i = 2
_PrimeCheck.loop:
    // điều kiện dừng: i * i > n
    // nếu i * i > n mà chưa chia hết cho số nào thì n là số nguyên tố
    mul         x2, x1, x1
    cmp         x2, x0
    b.gt        _PrimeCheck.is_prime

    // kiểm tra n % i == 0
    udiv        x3, x0, x1          // q = n / i
    msub        x4, x3, x1, x0      // r = n - (q * i)
    
    // nếu n % i == 0 (r == 0) thì n ko là số nguyên tố
    cmp         x4, #0
    b.eq        _PrimeCheck.not_prime

    add         x1, x1, #1          // i++
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

// thủ tục 4: tìm max trong mảng
// input: x0 (địa chỉ mảng), x1 (kích thước)
// output: x0 (max)
_FindMax:
    sub         sp, sp, #48         // backup nhiều hơn để bảo vệ x19-x23
    stur        x30, [sp, #40]
    stur        x19, [sp, #32]
    stur        x20, [sp, #24]
    stur        x21, [sp, #16]
    stur        x22, [sp, #8]
    stur        x23, [sp, #0]

    mov         x19, x0             // lưu địa chỉ mảng
    ldur        x0, [x19, #0]       // max = a[0] (gán mặc định)
    mov         x20, #0             // i = 0
_FindMax.loop:
    // lặp từ 0 -> n - 1
    cmp         x20, x1
    b.ge        _FindMax.exit

    lsl         x21, x20, #3
    add         x22, x19, x21
    ldur        x23, [x22, #0]      // nạp giá trị a[i] vào x23

    cmp         x23, x0             // so sánh a[i] với max hiện tại
    b.le        _FindMax.next       // nếu a[i] <= max thì tiếp tục

    mov         x0, x23             // cập nhật max mới
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

    // nhập n
    adrp        x0, tb1
    add         x0, x0, :lo12:tb1
    bl          printf
    adrp        x0, fmt1
    add         x0, x0, :lo12:fmt1
    adrp        x1, n 
    add         x1, x1, :lo12:n 
    bl          scanf

    // nạp n vào x19
    adrp        x19, n
    add         x19, x19, :lo12:n 
    ldur        x19, [x19]

    // gọi thủ tục nhập mảng
    adrp        x0, arr
    add         x0, x0, :lo12:arr
    mov         x1, x19
    bl          _InputArray

    // xuất mảng vừa nhập
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

    // kiểm tra và in số nguyên tố
    adrp        x0, tb_snt
    add         x0, x0, :lo12:tb_snt
    bl          printf

    mov         x20, #0     // i = 0
    mov         x21, #0     // sum = 0 (tính trung bình cộng)
main.loop:
    cmp         x20, x19            // duyệt toàn bộ arr
    b.ge        print_max_avg       // nếu duyệt xong thì nhảy để in max và tbc

    adrp        x22, arr            // lấy giá trị a[i]
    add         x22, x22, :lo12:arr
    lsl         x23, x20, #3
    add         x24, x22, x23
    ldur        x25, [x24, #0]      // x25 = a[i]

    add         x21, x21, x25       // sum += a[i]

    mov         x0, x25             // truyền a[i] vào thủ tục kiểm tra snt
    bl          _PrimeCheck
    
    cmp         x0, #1              // nếu trả về 1 thì a[i] là snt
    b.ne        main.next           // nếu không thì tiếp tục

    // in ra số nguyên tố
    adrp        x0, fmt2        
    add         x0, x0, :lo12:fmt2
    mov         x1, x25
    bl          printf
main.next:
    add         x20, x20, #1        // i++
    b           main.loop

print_max_avg:
    // tìm và in ra giá trị lớn nhất
    adrp        x0, arr
    add         x0, x0, :lo12:arr
    mov         x1, x19
    bl          _FindMax            // gọi thủ tục tìm max
    mov         x22, x20            // lưu kết quả max vào x22

    adrp        x0, tb_max
    add         x0, x0, :lo12:tb_max
    mov         x1, x22             // truyền max vào để in 
    bl          printf

    // tính và in ra trung bình cộng
    sdiv        x1, x21, x19        // trung bình cộng = sum / n
    adrp        x0, tb_tbc
    add         x0, x0, :lo12:tb_tbc
    bl          printf

exit:
    ldur        x30, [sp, #8]
    add         sp, sp, #16
    mov         x0, #0
    mov         x8, #93
    svc         #0
