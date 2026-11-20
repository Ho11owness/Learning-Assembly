; 11/20/2026
; Training exercise 03 — String to unsigned integer
; Write your own simplified implementation of atoi, without using any external library.

; Retrieve the first command-line argument, convert it into an unsigned integer and store the result in ebx.

; Test cases

; Command	   Expected EBX	   Exit status
; ./main 1234	  1234	            0
; ./main 65535	  65535	            0
; ./main 00042	  42	            0
; ./main 0	      0	                0
; ./main 1000000  1000000	        0
; ./main 12a3	  Unspecified	    1
; ./main ""	      Unspecified	    1
; ./main	      Unspecified	    1

; Constraints
; - Valid numerical inputs range from 0 to 1,000,000.
; - Reject non-digit characters.
; - Reject empty strings and missing arguments.
; - Negative numbers and arithmetic overflow handling are outside the scope of this exercise.
; - Time complexity: O(n).
; - Auxiliary space: O(1).

bits 64
default rel

section .text
global _start

; EBX = Accumulated integer
; EAX = Syscall number
; EDI = Exit status
; RSI = Pointer to the current character
; EDX = Current character

_start:
    mov edi, 1
    
    ; if no argument is provided
    cmp qword [rsp], 2
    jb done

    xor ebx, ebx
    mov rsi, [rsp + 16]

    ; reject empty strings
    cmp byte [rsi], 0
    je done

    loop: 
        movzx edx, byte [rsi]

	    test edx, edx
	    jnz checkRange

	    xor edi, edi
	    jmp done
    
    checkRange:
        cmp edx, byte '0'
	    jb done

	    cmp edx, byte '9'
	    ja done

    convertDigit:
        sub edx, '0'
        
	    imul ebx, 10
	    add ebx, edx

	    inc rsi	
	    jmp loop

    done:
        mov eax, 60
	    syscall

