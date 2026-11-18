bits 64
default rel

; Challenge 06 — Remove zero values
; You are given an array of unsigned integers ranging from 0 to 65,535.

; Your objective is to remove all zero values by moving the non-zero elements to the beginning of the array, preserving their original order.

; Fill the remaining positions with zeros.

; Examples

; Initial array

; 10 0 250 0 0 8000 42 0

; Expected array

; 10 250 8000 42 0 0 0 0

; Requirements
; - Choose your own data and register sizes.
; - Automatically calculate the array length.
; - Modify the array in place.
; - Store the number of non-zero elements in ebx.
; - Handle empty arrays.
; - Exit with status 0.

; Test cases

; Input	              Expected array      EBX
; [10, 0, 20, 0, 30]  [10, 20, 30, 0, 0]   3
; [0, 0, 0]	          [0, 0, 0]	           0
; [10, 20, 30]	      [10, 20, 30]	       3
; [0, 10]	          [10, 0]	           1
; []	              []	               0

section .data
    numbers dw 10, 0, 20, 0, 30
    length equ ($ - numbers) / 2

section .text
global _start

_start:
    mov ebx, 0
    
    mov eax, length
    cmp eax, 0
    je finish
    
    mov ecx, 0 ; loop index
    lea rsi, [numbers]

    repeat:
        lea r9, [rsi + rcx * 2] ; pointer to current element
        cmp word [r9], 0
	    je check
	    inc ebx
	    mov r10d, ebx
	    sub r10d, 1
	    lea r11, [rsi + r10 * 2] ; pointer to swap position
	    movzx edx, word [r9]
	    cmp r9, r11
	    je check
	    mov [r11], dx
	    mov word [r9], 0

    check:
        inc ecx
	    cmp ecx, eax
	    jb repeat

    finish:
	    mov eax, 60
	    mov edi, 0
	    syscall
