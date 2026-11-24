; 11/24/2026
; Assembly Challenge — Checkout Calculator
; Difficulty 3/5
; Stack · ABI · Function Calls
;
; Scenario
; You're developing the calculation engine for a small checkout system.
;
; Given a product's price, a discount percentage, and a tax percentage, calculate the final amount the customer must pay.
;
; All monetary amounts are represented in cents, using unsigned 64-bit integers. This avoids floating-point calculations.
;
; Functions to implement
;
; uint64_t apply_discount(
;     uint64_t price,
;     uint64_t discount_percent
; );
;
; uint64_t apply_tax(
;     uint64_t price,
;     uint64_t tax_percent
; );
;
; uint64_t checkout_total(
;     uint64_t price,
;     uint64_t discount_percent,
;     uint64_t tax_percent
; );
;
;
; Each function serves a genuine purpose.
;
; apply_discount calculates the price after applying a percentage discount.
;
; apply_tax calculates the price after adding a percentage tax.
;
; checkout_total must call both functions, applying the discount first and then the tax.
;
; Example
; A product costs €100.00. There's a 20% discount and a 10% tax.
;
; Original price -> 10,000 cents
;
; Discount (20%) ->  −2,000 cents
;
; Discounted price -> 8,000 cents
;
; Tax (10%) -> +800 cents
;
; Final price -> 8,800 cents
;
;
; Test cases
; Price	Discount %	Tax %	Expected result
; 10000    20	         10           8800
; 5000     0	         21           6050
; 2000     50	         0            1000
; 100      100	         20           0
; 100      33	         10           73
; 9999     15	         8            9180
; 0        50	         20           0
;
; For fractional cents, round down the discount or tax amount using integer division. For example, a 33% discount on 100 cents subtracts 33 cents, leaving 67.
;
; Requirements
; - NASM, x86-64 Linux, System V AMD64 ABI.
; - Implement all three functions in Assembly.
; - checkout_total must call the other two functions.
; - Respect 16-byte stack alignment before every call.
; - Preserve callee-saved registers.
; - Restore rsp correctly before returning.
; - No dynamic memory allocation.
; - You may assume percentages are between 0 and 100, and prices are at most 10^12 cents, so the calculations fit in 64 bits.
; - You may use any instructions you've learned.

bits 64
default rel

section .text
global checkout_total
global apply_discount
global apply_tax

checkout_total:
; Arguments:
; RDI = Price
; RSI = Discount percent
; RDX = Tax percent
;
; Returns:
; RAX = Total price

    push rdx

    call apply_discount
    
    mov rdi, rax
    pop rdx
    sub rsp, 8
    mov rsi, rdx
    call apply_tax

    add rsp, 8
    ret

apply_discount:
; Arguments:
; RDI = Price
; RSI = Discount percent
;
; Returns:
; RAX = Discounted price
    
    mov rax, rdi
    xor edx, edx
    mov rcx, 100

    mov r8, rax
    
    mul rsi
    div rcx
    sub r8, rax
    mov rax, r8

    ret

apply_tax:
; Arguments:
; RDI = Price
; RSI = Tax percent
;
; Returns:
; RAX = Taxed price

    mov rax, rdi
    xor edx, edx
    mov rcx, 100

    mov r8, rax

    mul rsi
    div rcx
    add r8, rax
    mov rax, r8

    ret
