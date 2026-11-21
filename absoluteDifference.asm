; 11/21/2026
; Training exercise 04 — First reusable function
; Implement the Assembly equivalent of this C function:
; unsigned int absoluteDifference(unsigned int a, unsigned int b);


; The function must return the absolute difference between two unsigned integers.

; Test cases

; Argument A    Argument B      Return value
; 10               30                20
; 30               10                20
; 42               42	             0
; 0                100               100
; 65535            0                 65535

; Requirements
; - Input values range from 0 to 65,535.
; - Respect the System V AMD64 calling convention.
; - Inspect each return value using GDB.
; - Only terminate the process from _start.
; - Leave the stack balanced.

bits 64
default rel

section .text
global _start

_start:
    mov esi, [rsp]

    cmp esi, 3
    jb error
    
    ; Convert arguments to integers
    mov rdi, [rsp + 16]
    call atoi
    mov r8d, eax

    mov rdi, [rsp + 24]
    call atoi
    mov r9d, eax
    
    mov edi, r8d
    mov esi, r9d
    call absoluteDifference
    mov ebx, eax
    xor edi, edi
    jmp done

absoluteDifference:
    ; Arguments:
    ; RDI = First operand
    ; RSI = Second operand

    ; Return value:
    ; RAX = Absolute difference between RDI and RSI

    ; Clobbers:
    ; RAX, RDI, RSI

    cmp edi, esi
    je areEqual
    jb esiIsMax
    ja ediIsMax
    ret
    
    areEqual:
        xor eax, eax
	    ret

    rsiIsMax:
        mov eax, esi
	    sub eax, edi
	    ret

    rdiIsMax:
        mov eax, edi
	    sub eax, esi
	    ret

atoi:
    ; Arguments:
    ; RDI = Pointer to a valid null-terminated string
    
    ; Return value:
    ; RAX = Converted integer if success
    ; RAX = 0 if invalid input

    ; Clobbers:
    ; RAX, RDI, RDX

    ; Variables:
    ; EDX = Current character 

    xor eax, eax

    cmp byte [rdi], 0
    je invalidInput

    loop:
        movzx edx, byte [rdi]

	    test edx, edx
	    jnz checkRange

	    ret

    checkRange:
        cmp edx, byte '0'
        jb invalidInput

        cmp edx, byte '9'
        ja invalidInput

    convertDigit:
        sub edx, '0'

	    imul rax, 10
	    add rax, rdx

	    inc rdi
	    jmp loop

    invalidInput:
        xor eax, eax
	    ret

error:
    mov edi, 1

done:
    mov eax, 60
    syscall
