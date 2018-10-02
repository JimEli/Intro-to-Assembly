TITLE MASM Template (main.asm)

; Description: Lab #1 EC
; James Eli
; 9/3/2018
;
; Using lab1.asm as your start. 
; Ask the user for 2 different numbers. Subtract them.
; If the difference is zero, print "the numbers are equal".
; If the difference is positive, print "the first number is greater than the second".
; If the difference is negative, print "the second number is greater than the first one".
; Turn in by next Monday, complete with test cases and documentation. 
; Label: Lab-EC1-name

INCLUDE Irvine32.inc

.data

; Text prompts.
inPrompt      BYTE "Input an integer (-2147483648 to 2147483647): ", 0
inFailPrompt  BYTE " Try input again!", 0dh, 0ah, 0
errorPrompt   BYTE " Beware! A math overflow occurred.", 0dh, 0ah, 0
resultEqual   BYTE "the numbers are equal", 0dh, 0ah, 0
resultBigger  BYTE "the first number is greater than the second", 0dh, 0ah, 0
resultSmaller BYTE "the second number is greater than the first one", 0dh, 0ah, 0

.code

;---------------------------------------------------
; Prompt for user input. Get an integer using Irvine's 
; ReadInt function. Checks overflow flag for validity 
; and repeats if necessary. Receives nothing. Returns 
; integer in eax.
;---------------------------------------------------
GetInput PROC

@@:
	mov  edx, OFFSET inPrompt      ; Prompt for numerical input.
	call WriteString               ; Display prompt on console.
	call ReadInt                   ; Read 32-bit integer from console.
	jno  @F	                       ; If carry set, invalid input occured.

	Mov  edx, OFFSET inFailPrompt  ; Report bad input.
	call WriteString               ; Display on console.
	jmp  @B                        ; Do over.
@@:
	ret                            ; Return valid number in eax.

GetInput ENDP

;---------------------------------------------------
; Program entry point.
;---------------------------------------------------
main PROC

call Clrscr

	call GetInput                  ; Get 1st number.
	mov  ebx, eax                  ; Save number in ebx.

	call GetInput                  ; Get 2nd number.
	sub  ebx, eax                  ; Add 1st and 2nd number, result in ebx.
	jno  @F                        ; Check for math overflow.
	mov  edx, OFFSET errorPrompt
	call WriteString               ; Output message on console.
	jmp  over

@@:
	cmp  ebx, 0                    ; Compare result with 0.
	je   equal
	jg   bigger
	jl   smaller

smaller:
	mov  edx, OFFSET resultSmaller
	call WriteString               ; Output message on console.
	jmp  over

equal:
	mov edx, OFFSET resultEqual
	call WriteString               ; Output message on console.
	jmp  over

bigger:
	mov edx, OFFSET resultBigger 
	call WriteString               ; Output message on console.

over:
	exit

main ENDP
END main
