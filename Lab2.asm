TITLE Multiplication (main.asm)

; Description: Lab #2 Multiplication
; James Eli
; 9/3/2018 (10/23/2018 updated)
;
; Multiplication Fun!!!
;
; Part 1: Call Mul from a procedure (50 pts)
; Create a procedure, and in that procedure multiply two numbers 
; together using mul. Then call the procedure from the main procedure.
;
; Part 2: Do bitwise mulitiplication using only 
; shift and add statements (30 pts)
; In your multiplication procedure multiply two numbers not using mul 
; but by combining a fixed number of shift and add commands. For this 
; part you only need to be able to handle 8 bit numbers so you don't 
; need to use a loop for this part 
;
; Part 3: Add loop to bitwise multiplication procedure (20 pts)
; Instead of using a fixed number of bitwise multipliers, use a loop 
; to run the bitwise multiplication
;
; EC 15 pts:
; Create a bitwise division procedure.
;
; Notes:
; (1) Russian peasant multiplication routine researched here:
; https://en.wikipedia.org/wiki/Ancient_Egyptian_multiplication
;
; (2) Binary division by shift/subtraction researched here:
; http://courses.cs.vt.edu/~cs1104/BuildingBlocks/divide.030.html
;

INCLUDE Irvine32.inc

.data

; Text prompts.
inPrompt      BYTE "Input an unsigned integer (1 to 65,535): ", 0
inFailPrompt  BYTE " Invalid input, try input again!", 0ah, 0
outPrompt1    BYTE 0ah, "Multiply (MUL) result = ", 0
outPrompt2    BYTE 0ah, "Multiply (SHR/ADD) result = ", 0
outPrompt3    BYTE 0ah, "Division (SHL/SUB) result = ", 0
outPrompt4    BYTE ", remainder = ", 0
errorPrompt   BYTE " Beware! A math error occurred.", 0ah, 0
crlf_         BYTE 0dh, 0ah

; Multiplicands temporary storage.
multiplicand1 DWORD ?
multiplicand2 DWORD ?

; Flag for math overflow.
mathError     DWORD 0 
OF_ERROR      EQU   1
DZ_ERROR      EQU   2

; Maximum input value (65,535).
MaxInputVal   EQU   0ffffh

.code

;---------------------------------------------------
; Macro to output string to console.
;---------------------------------------------------
mOutString MACRO string:REQ
	mov  edx, OFFSET string ; Addr of text string.
	call WriteString        ; Display on console.
ENDM

;---------------------------------------------------
; Multiply 2 numbers (giving 32-bit answer). Checks 
; for overflow. Receives multiplicands in eax and 
; ebx. Returns answer in eax.
;---------------------------------------------------
multiply2 PROC USES ebx

  mov  mathError, 0        ; No error.
  mul  ebx                 ; eax=eax*ebx
  jno  @F                  ; Check for overflow.
  mov  mathError, OF_ERROR ; Flag error.

@@:
  ret                      ; Return result in eax.

multiply2 ENDP

;---------------------------------------------------
; Russian peasant multiplication routine. Performs
; multiplication via shift/add using the following 
; algorithm:
;   i -> 0
;   j -> 0
;   sum -> 0
;   while (i >= 1)
;     if (i % 2 != 0)
;       sum -> sum + j
;     j -> j + j
;     i -> i >> 2
; Receives multiplicands in x and y. Returns answer 
; in eax.
;---------------------------------------------------
peasantMultiply PROC USES ecx edx x:DWORD, y:DWORD

	mov  ecx, x         ; Put multiplicands x,y into ecx, edx.
	mov  edx, y                
	cmp  ecx, edx       ; Put smaller value into edx.
	ja   @F             ; Not really necessary, but will loop less.
	xchg ecx, edx

@@:
	cmp  ecx, 1         ; Check for multiplication by 1.
	jne  @F
	mov  eax, edx       ; Short circuit, and return result.
	ret

@@:
	cmp  edx, 1         ; Check for multiplication by 1.
	jne  @F
	mov  eax, ecx       ; Short circuit, and return result.
	ret

@@:
	xor  eax, eax       ; Zeroize answer (eax).
	jmp  start          ; Start multiplication.

@@:
	add  ecx, ecx       ; x *= 2
	shr  edx, 1         ; y /= 2 via right shift by 1 bit.
	cmp  edx, 1         ; y <= 1 ?
	jbe  @F             ; Finished ? 

start:
	test edx, 1         ; Test if y odd ?
	je   @B             ; Jump if y even.
	add  eax, ecx       ; eax += x
	jmp  @B             ; Repeat.

@@:
	add  eax, ecx       ; eax += x
	ret                 ; Return answer in eax.

peasantMultiply ENDP

;---------------------------------------------------
; Division using shift/subtraction. Receives input 
; in dividend and divisor. Returns quotent in eax, 
; and remainder in ebx.
;---------------------------------------------------
division PROC USES ecx edx dividend:DWORD, divisor:DWORD

	mov  eax, dividend  ; eax = dividend.
	mov  edx, divisor   ; edx = divisor.
	mov  ecx, 32        ; ecx = bits remaining.
	mov  ebx, 0         ; ebx = remainder.

	mov  mathError, 0   ; No error.
	cmp  edx, 0         ; Prevent div by zero.
	jne  L1
	xor  eax, eax       ; Flag attempted div by zero.
	mov  mathError, DZ_ERROR 
	ret

L1:
	shl  eax, 1         ; Dividend /= 2.
	adc  ebx, ebx       ; Remainder*2 + quotent/2 carry.
	cmp  ebx, edx       ; Remainder >= divisor ?
	jb   L2             ; Remainder < divisor.

	sub  ebx, edx       ; Remainder -= divisor.
	add  eax, 1         ; Quotent++.

L2:                         ; Quotent bit == 0.
	loop L1             ; Loop if bits remain.

	ret                 ; eax = quotent, ebx = remainder.

division ENDP

;---------------------------------------------------
; Prompt for user input, getting a 32-bit unsigned 
; integer value using Irvine's ReadDec function. 
; Checks for valid input (1 - 65,535) and repeats if 
; necessary. No regs stored/restored. Returns value 
; in eax.
;---------------------------------------------------
GetInput PROC

I1:
	mOutString inPrompt      ; Prompt for numerical input.
	call ReadDec             ; Read 32-bit unsigned integer from console.
	
	cmp  eax, 0              ; Validate input.
	je   I2                  ; Input == 0 ?

	cmp  eax, MaxInputVal    ; max == 0ffffh.
	jbe  I3                  ; Input > 16-bits ?

I2:
	mOutString inFailPrompt  ; Report invalid input.
	jmp  I1                  ; Do over.

I3:
	ret                      ; Return valid number in eax.

GetInput ENDP

;---------------------------------------------------
; Program entry point.
;---------------------------------------------------
main PROC

	call Clrscr              ; Clear console.

	; Part 1: Call Mul from a procedure.
	call GetInput            ; Get 1st number.
	mov  ebx, eax            ; Save number in ebx.
	mov  multiplicand1, eax  ; Save as m1.

	call GetInput            ; Get 2nd number.
	mov  multiplicand2, eax  ; Save as m2.
	
	call multiply2           ; Multiply (eax*ebx).

	mOutString outPrompt1    ; Output result prompt text.
	call WriteDec            ; Output result to console.

	cmp  mathError, OF_ERROR ; Math overflow?
	jne  @F
	mOutString errorPrompt   ; Math error detected.

@@:
	; Part 2: Do bitwise mulitiplication using only 
	; Part 3: Add loop to bitwise multiplication procedure.
	INVOKE peasantMultiply, multiplicand1, multiplicand2
	mOutString outPrompt2    ; Output result prompt text.
	call WriteDec            ; Output result to console.

	; EC: Create a bitwise division procedure.
	INVOKE division, multiplicand1, multiplicand2

	.IF mathError != 0         
	  mOutString errorPrompt ; Output result prompt text.
	  jmp @F
	.ENDIF

	mOutString outPrompt3    ; Output result prompt text.
	call WriteDec            ; Output result to console.

	.IF eax == 0             ; Need to show remainder ?
	   je @f
	.ENDIF
	.IF ebx == 0             ; Any remainder ?
	   je @f
	.ENDIF
;	The above code is logically same as:
;	cmp  eax, 0              ; Need to show remainder ?
;	je   @f
;	cmp  ebx, 0              ; Any remainder ?
;	je   @f

	mOutString outPrompt4    ; Output remainder prompt text.
	mov  eax, ebx            ; eax = remainder.
	call WriteDec            ; Output result to console.

@@:
	mOutString crlf_         ; Output crlf.
	exit

main ENDP
END main

