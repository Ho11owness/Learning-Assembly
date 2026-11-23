bits 64
default rel

MAX_UINT64 equ 0xFFFFFFFFFFFFFFFF

section .text
global utoa_u64

utoa_u64:
; Converts a 64-bit unsigned integer to a null terminated string

; Arguments:
; RDI = Unsigned 64-bit integer to convert
; RSI = Pointer to the output buffer
; RDX = Buffer capacity in bytes

; Variables:
; RAX = Unsigned 64-bit integer to convert (moved from RDI because div will overwrite it)
; R8 = Buffer capacity (moved from RDX because div will overwrite it)
; R9 = 10
; R10 = Number of digits
; R11 = Decimal threshold used for digit counting

; Returns:
; RAX = 0 if success, 1 if NULL output pointer, 2 if insufficient buffer capacity
    
    ; null pointer check
    test rsi, rsi
    jz .nullPointer

    ; Determine number of digits to verify whether the integer fits in the buffer
    mov r11, 10
    cmp rdi, r11
    jb .lessThan10

    mov r11, 100
    cmp rdi, r11
    jb .lessThan100

    mov r11, 1000
    cmp rdi, r11
    jb .lessThan1000

    mov r11, 10000
    cmp rdi, r11
    jb .lessThan10000

    mov r11, 100000
    cmp rdi, r11
    jb .lessThan100000

    mov r11, 1000000
    cmp rdi, r11
    jb .lessThan1000000

    mov r11, 10000000
    cmp rdi, r11
    jb .lessThan10000000

    mov r11, 100000000
    cmp rdi, r11
    jb .lessThan100000000

    mov r11, 1000000000
    cmp rdi, r11
    jb .lessThan1000000000
    
    mov r11, 10000000000
    cmp rdi, r11
    jb .lessThan10000000000

    mov r11, 100000000000
    cmp rdi, r11
    jb .lessThan100000000000

    mov r11, 1000000000000
    cmp rdi, r11
    jb .lessThan1000000000000

    mov r11, 10000000000000
    cmp rdi, r11
    jb .lessThan10000000000000

    mov r11, 100000000000000
    cmp rdi, r11
    jb .lessThan100000000000000

    mov r11, 1000000000000000
    cmp rdi, r11
    jb .lessThan1000000000000000

    mov r11, 10000000000000000
    cmp rdi, r11
    jb .lessThan10000000000000000

    mov r11, 100000000000000000
    cmp rdi, r11
    jb .lessThan100000000000000000

    mov r11, 1000000000000000000
    cmp rdi, r11
    jb .lessThan1000000000000000000

    mov r11, 10000000000000000000
    cmp rdi, r11
    jb .lessThan10000000000000000000
    
    mov r11, MAX_UINT64
    cmp rdi, r11
    jbe .lessThanOrEqualToMAX_UINT64
    
    .lessThan10:
        mov r10, 1
        jmp .checkBufferCapacity

    .lessThan100:
        mov r10, 2
        jmp .checkBufferCapacity

    .lessThan1000:
        mov r10, 3
        jmp .checkBufferCapacity

    .lessThan10000:
        mov r10, 4
        jmp .checkBufferCapacity

    .lessThan100000:
        mov r10, 5
        jmp .checkBufferCapacity

    .lessThan1000000:
        mov r10, 6
        jmp .checkBufferCapacity

    .lessThan10000000:
        mov r10, 7
        jmp .checkBufferCapacity

    .lessThan100000000:
        mov r10, 8
        jmp .checkBufferCapacity

    .lessThan1000000000:
        mov r10, 9
        jmp .checkBufferCapacity

    .lessThan10000000000:
        mov r10, 10
        jmp .checkBufferCapacity

    .lessThan100000000000:
        mov r10, 11
        jmp .checkBufferCapacity

    .lessThan1000000000000:
        mov r10, 12
        jmp .checkBufferCapacity

    .lessThan10000000000000:
        mov r10, 13
        jmp .checkBufferCapacity

    .lessThan100000000000000:
        mov r10, 14
        jmp .checkBufferCapacity

    .lessThan1000000000000000:
        mov r10, 15
        jmp .checkBufferCapacity

    .lessThan10000000000000000:
        mov r10, 16
        jmp .checkBufferCapacity

    .lessThan100000000000000000:
        mov r10, 17
        jmp .checkBufferCapacity

    .lessThan1000000000000000000:
        mov r10, 18
        jmp .checkBufferCapacity

    .lessThan10000000000000000000:
        mov r10, 19
        jmp .checkBufferCapacity

    .lessThanOrEqualToMAX_UINT64:
        mov r10, 20
        jmp .checkBufferCapacity
    
    .checkBufferCapacity:
        inc r10 ; accounting for null terminator
        cmp r10, rdx
	ja .insufficientBufferCapacity

    ; moving arguments since the div instructions will overwrite them
    mov rax, rdi
    mov r8, rdx
    mov r9d, 10

    ; inserting the null terminator first
    dec r10
    mov byte [rsi + r10], 0 

    .loop:
        dec r10
        xor edx, edx
	div r9
	add rdx, '0'
	mov byte [rsi + r10], dl
	test rax, rax
	jnz .loop

    .done:
        mov eax, 0
	ret
    
    .nullPointer:
        mov eax, 1
	ret

    .insufficientBufferCapacity:
        mov eax, 2
	ret
