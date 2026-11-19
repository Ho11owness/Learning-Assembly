bits 64
default rel

; 11/19/2026
; Challenge 07 — Remove consecutive duplicates

; Given a sorted array of unsigned integers ranging from 0 to 65,535, remove duplicate values in place so that each distinct value appears exactly once. Array length: 0 <= n <= 1,000,000.

; Fill the remaining positions with zeros.

; Example

; Initial array

; 10 10 20 20 20 30 40 40


; Expected array
; 10 20 30 40 0 0 0 0

; EBX — Number of distinct values 4

; Requirements
; - Automatically calculate the array length.
; - Modify the array in place.
; - Preserve the order of distinct elements.
; - Store the number of distinct elements in ebx.
; - Handle empty arrays.
; - Exit with status 0.

; Test cases

; Input	            Expected output    EBX
; [10, 10, 20, 30]  [10, 20, 30, 0]	    3
; [5, 5, 5, 5]	    [5, 0, 0, 0]	    1
; [10, 20, 30]	    [10, 20, 30]	    3
; [0, 0, 10, 10]    [0, 10, 0, 0]	    2
; [42]	            [42]	            1
; []	            []	                0

; Idea in Python

; CHALLENGE STARTS HERE

; Python idea

; def removeConsecutiveDuplicates():
;     distinct_elements = 0
    
;     if not array:
;         return distinct_elements
    
;     first_occurrence = array[0]
    
;     for i in range(len(array)):
;         if array[i] != first_occurrence or i == 0:
;             distinct_elements += 1
;             first_occurrence = array[i]
        
;         array[i] = 0
;         array[distinct_elements - 1] = first_occurrence
     
;     return distinct_elements

section .data
    array dw 10, 20, 30
    arrayLength equ ($ - array) / 2

section .text
global _start

; EBX = Number of distinct elements
; EAX = Array length
; ECX = Loop counter
; RSI = Pointer to the beginning of the array
; EDI = First occurrence of an integer from the array
; RDX = Pointer to the current iteration's element

_start:
    xor ebx, ebx

    mov eax, arrayLength
    test eax, eax
    jz done

    ; initialization
    lea rsi, [array]
    movzx edi, word [rsi]
    xor ecx, ecx

    loop:
        lea rdx, [rsi + rcx * 2]
       
        ; if i == 0 or array[i] != first_occurence -> True
	test ecx, ecx
	je ifIsFirstOccurrence

	cmp [rdx], di
        jne ifIsFirstOccurrence
	je swap

    ifIsFirstOccurrence:
        inc ebx
	movzx edi, word [rdx]

    swap:
        mov word [rdx], 0
	mov [rsi + rbx * 2 - 2], di
	inc ecx
	cmp ecx, eax
	jb loop

    done:
        mov eax, 60
	xor edi, edi
	syscall
