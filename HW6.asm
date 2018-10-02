; Homework #6
; James Eli
; 9/1/2018
;
; Develop an ASM program that draws a square using ASCII 
; characters and ASM video commands. Utilizes the extended 
; ASCII character set.
;

.386
.MODEL flat, stdcall

STD_OUTPUT_HANDLE EQU -11      ; Windows standard ouput handle request.
MAX_WIDTH         EQU 80       ; Maximum rows allowed.
MAX_HEIGHT        EQU 20       ; Maximum columns allowed.
DEMO_WIDTH          = 20       ; Demo square size.
DEMO_HEIGHT         = 10       ; Demo square size.

; Windows function prototypes.
GetStdHandle PROTO, nStdHandle: DWORD 

WriteConsoleA PROTO, handle: DWORD, lpBuffer: PTR BYTE,
  nNumberOfBytesToWrite: DWORD, lpNumberOfBytesWritten: PTR DWORD, lpReserved: DWORD

ExitProcess PROTO, dwExitCode: DWORD 

.data

consoleOutHandle  dd ?          ; Windows output handle.
bytesWritten      dd ?          ; place holder (not used).

; Characters (extended ASCII) define box.
TOP_LEFT_CHAR     db 0c9h       ; xASCII top-left-corner double line.
ROW_CHAR          db 0cdh       ; xASCII double horizontal lines.
TOP_RIGHT_CHAR    db 0bbh       ; xASCII top-right-corner double lines.
COLUMN_CHAR       db 0bah       ; xASCII double vertical lines.
BOTTOM_LEFT_CHAR  db 0c8h       ; xASCII bottom-left-corner double line.
BOTTOM_RIGHT_CHAR db 0bch       ; xASCII bottom-right-corner double line.
SPACE_CHAR        db 020h       ; ASCII space character.
LINE_FEED_CHAR    db 0ah        ; ASCII line feed character.

;---------------------------------------------------
; Macro to output a single character to console.
;---------------------------------------------------
mOutChar MACRO Character:REQ

	mov   edx, offset Character
	call  WriteChar

ENDM

;---------------------------------------------------
; Macro to display top and bottom rows of square.
;---------------------------------------------------
mWriteRow MACRO leftChar:REQ, rightChar:REQ

	mOutChar leftChar           ; display left character for row.
	mov   ecx, eax              ; loop for rows count.
	mov   edx, offset ROW_CHAR  ; load edx with straight row.

@@:
	call  WriteChar             ; write char to console.
	loop  @B
	mOutChar rightChar          ; display right character for row.
	mOutChar LINE_FEED_CHAR

ENDM

;---------------------------------------------------
; Macro to validate register>0 && register<max.
;---------------------------------------------------
mValidate MACRO reg:REQ, max:REQ

	.IF reg >= max || reg == 0
	  mov reg, max
	.ENDIF

ENDM

.code

;---------------------------------------------------
; Windows procedure to display 1 char on console.
; edx = character to display.
;---------------------------------------------------
WriteChar PROC 

	pushad                      ; Save registers.
	pushfd                      ; Save flags.

	cld                         ; Clear direction flag.
	INVOKE WriteConsoleA, consoleOutHandle, edx, 1, offset bytesWritten, 0

	popfd                       ; Restore flags.
	popad                       ; Restore registers.
	ret

WriteChar ENDP

;---------------------------------------------------
; Box drawing function.
;---------------------------------------------------
DrawBox PROC USES ecx edx width_:DWORD, height_:DWORD

	mov  eax, width_           ; Validate width.
	mValidate eax, MAX_WIDTH

	; Display top row of square.
	mWriteRow TOP_LEFT_CHAR, TOP_RIGHT_CHAR

	mov  ecx, height_          ; Validate height
	mValidate ecx, MAX_HEIGHT

drawColumns:
	; Draw left side of square.
	mOutChar COLUMN_CHAR
	push ecx                   ; Save outer loop counter.
	mov  ecx, eax              ; Inner loop counter.   

@@:
	; Move to right side.
	mOutChar SPACE_CHAR
	loop @B

	pop  ecx                   ; Restore loop counter.
	;Draw right side of square followed by LF.	
	mOutChar COLUMN_CHAR
	mOutChar LINE_FEED_CHAR
	loop drawColumns

drawBottomRow:
	mWriteRow BOTTOM_LEFT_CHAR, BOTTOM_RIGHT_CHAR
	ret
	
DrawBox ENDP

;---------------------------------------------------
; Main program entry point.
;---------------------------------------------------
main PROC

	; Get console output handle.
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov   consoleOutHandle, eax 

	; Draw a demonstration square on console.
	INVOKE DrawBox, DEMO_WIDTH, DEMO_HEIGHT

	INVOKE ExitProcess, 0 

main ENDP
END main
