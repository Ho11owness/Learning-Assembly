bits 64
default rel

section .bss
    result resq 1

section .text
global parse_u64

parse_u64:
; Converts a null terminated decimal string into a 64-bit unsigned integer

; Arguments:
; RDI = Pointer to the beginning of the string / to the current character
; RSI = Pointer to the result's storage location

; Variables:
; RAX = Accumulated integer
; R8D = Current character
; R9 = Contains 10. Used for multypling RAX implicitly

; Clobbers:
; RAX, RDI, RDX, R8, R9

; Returns:
; EAX = 0 if success, 1 if invalid input, 2 if overflow
    
    ; null pointers
    test rdi, rdi
    jz .invalidInput

    test rsi, rsi
    jz .invalidInput

    ; empty string
    cmp byte [rdi], 0
    je .invalidInput
     
    xor rax, rax
    mov r9, 10

    .loop:
        movzx r8d, byte [rdi]

	    cmp r8d, '0'
	    jb .invalidInput

	    cmp r8d, '9'
	    ja .invalidInput
        
    	mul r9
	    jc .overflow
	    sub r8d, '0'
	    add rax, r8
	    jc .overflow

	    inc rdi
	    cmp byte [rdi], 0
	    jne .loop

	    mov [rsi], rax
	    xor rax, rax
	    ret

    .invalidInput:
        mov eax, 1
	    ret

    .overflow:
        mov eax, 2
	    ret
