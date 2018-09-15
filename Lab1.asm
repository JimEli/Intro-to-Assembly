TITLE MASM Template (main.asm)
; Description: Lab #1 Hello World Program.
; James Eli
; 8/29/2018
;
; Adaptation of Kip Irvine's Project_sample for CIS 250 Lab #1.
; Display a simple text message on the console and perform 
; some very basic math on numbers input by user. Checks for
; signed 32-bit integer overflow.
;
INCLUDE Irvine32.inc

;---------------------------------------------------
; Macro to output string to console.
;---------------------------------------------------
mOutString MACRO string:REQ
	mov  edx, OFFSET string ; Get addr of prompt string.
	call WriteString        ; Display prompt on console.
ENDM

.data
; Text prompts.
myMessage    BYTE "Hello, James Eli", 0dh, 0ah, 0
inPrompt     BYTE "Input an integer (-2147483648 to 2147483647): ", 0
inFailPrompt BYTE " Try input again!", 0dh, 0ah, 0
outPrompt    BYTE "Result = ", 0
errorPrompt  BYTE " Beware! A math overflow occurred.", 0dh, 0ah, 0

; Flag for math overflow
mathError    DWORD 0 
OF_ERROR     EQU   1 

.code
;---------------------------------------------------
; Prompt for user input. Get an integer using Irvine's 
; ReadInt function. Checks carry flag for validity and 
; repeats if necessary. Receives nothing. Returns 
; integer in eax.
;---------------------------------------------------
GetInput PROC
@@:
	mOutString inPrompt     ; Prompt for numerical input.
	call ReadInt            ; Read 32-bit integer from console.
	jno  @F	                ; If carry set, invalid input occured.
	mOutString inFailPrompt ; Report bad input.
	jmp  @B                 ; Do over.

@@:
	ret                     ; Return valid number in eax.
GetInput ENDP

;---------------------------------------------------
; Program entry point.
;---------------------------------------------------
main PROC
	call Clrscr

	; Hello world.
	mOutString myMessage     ; Load edx with message addess.

	; Display registers.
	call DumpRegs            ; Call Irvine's DumpRegs function.

	; Extra credit input data and perform basic math.
	call GetInput            ; Get 1st number.
	mov  ebx, eax            ; Save number in ebx.

	call GetInput            ; Get 2nd number.
	add  ebx, eax            ; Add 1st and 2nd number, result in ebx.
	jno  @F
	mov  mathError, OF_ERROR ; Overflow detected.
@@:
	call GetInput            ; Get 3rd number.
	sub  ebx, eax            ; Subtract 3rd number, result in ebx.
	jno  @F
	mov  mathError, OF_ERROR ; Overflow detected.
@@:
	mov  eax, ebx            ; Move result to eax.
	mOutString outPrompt     ; Output result text.
	call WriteInt            ; Output result to console.

	cmp  mathError, OF_ERROR ; Math overflow?
	jne  @F
	mOutString errorPrompt   ; Math error detected.
@@:
	exit
main ENDP
END main

