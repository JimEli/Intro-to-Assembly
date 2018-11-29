; James Eli
; 9/6/2018
;
; Part 1: Run Assembly in C code (75 pts)
; Run the code in Lab 4 Code
;
; Part 2: Dynamically Generate Prime Numbers
; Modify procedure.asm so that prime numbers are dynamically 
; calculated instead of looking up in an array. To find out 
; if an input, n, is a prime number, make a loop that ranges 
; from 3 to n/2, then divide n by i (the loop number), then 
; check the remainder of the division, if there is no 
; remainder for the division the number n is not prime.

.586P
.MODEL FLAT, stdcall ; Flat Memory Model

PUBLIC isPrime

.code

; -------------------------------------------------------- 
; Test if number is prime. Returns result/remainder in eax.
; -------------------------------------------------------- 
isPrime PROC USES ebx ecx edx, n:DWORD

	mov  eax, n      ; eax=number to test.

	cmp  eax, 0      ; Check special cases negative/zero?
	je   zero        ; Jump if eax==0
	jg   notNeg      ; Jump if eax>0
	neg  eax         ; Flip sign of negative n.

notNeg:
	dec  eax         ; 1 is not considered prime.
	jnz  notSpecial          

zero:
	ret              ; Return not prime special cases.

notSpecial:
	inc  eax         ; Reset n.
	mov  ebx, eax    ; ebx=n.
	mov  ecx, eax    ; ecx is divisor.
	shr  ecx, 1      ; ecx=n/2.

@@:
	cmp  ecx, 2      ; Loop until divisor=2.
	jb   @F
	xor  edx, edx    ; Zeroize edx.
	mov  eax, ebx    ; Reset dividend.
	div  ecx         ; eax=n/divisor.
    cmp  edx, 0      ; Remainder?
	je   @F          ; Remainder==0 means n not prime.
	dec  ecx         ; Divisor -= 1.
	jmp  @B          ; Repeat.

@@:
	mov eax, edx     ; Remainder signals result.
	ret

isPrime ENDP
END