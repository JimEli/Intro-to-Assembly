TITLE Lab #3 (main.asm)

COMMENT !
 Description: Lab #3 Arrays
 James Eli
 9/6/2018

 Lab 3: Exercise 10 on pg 364 of the textbook
 Learning Objectives
 - Understand and implement arrays
 - Manipulate data using strings

 Part 1 (50 pts) - Generate an array of formated characters
 In a procedure create a print a matrix that writes 
 stores and writes out characters in a format that 
 writes 4 characters per line and for 4 lines. For example:
   ABCD
   EFGH
   IJKL
   MNOP
 To do this write, create a matrix that can hold all 
 the letters, and mark the end of the line store a 
 new line character (0Dh, 0Ah). So your array will look 
 something like this "ABCD", 0Dh, 0Ah, "EFGH", 0Dh, 0Ah, etc.
 Then write the array out with call WriteString

 Part 2 (30 pts) - Write out random letters using RandomRange
 Using the commands
   mov eax, 26
   call RandomRange ; in the irvine library
 and an array made up of all the letters in the alphabet
 Write out a 4X4 matrix that prints out 16 random letters 
 taken from an alphabet matrix you created.

 Part 3 (20 pts) - Randomly generate vowels or consonants
 Using randomRange that selects 0 or 1. If the value is 0, 
 have your list randomly print out a vowel, if the value 
 returned is 1, have a consonant randomly printed out.

 Textbook exercise instructions: 
 10. Letter Matrix
 Create a procedure that generates a four-by-four matrix of 
 randomly chosen capital letters. When choosing the letters, 
 there must be a 50% probability that the chosen letter is a 
 vowel. Write a test program with a loop that calls your 
 procedure five times and displays each matrix in the console 
 window. Following is sample output for the first three matrices:
 D W A L
 S I V W
 U I O L
 L A I I

 K X S V
 N U U O
 O R Q O
 A U U T

 P O A Z
 A E A U
 G K A E
 I A G D
END !

INCLUDE Irvine32.inc

; Number of demonstration arrays.
NUMBER_ARRAYS EQU 3
; Character matrix size.
MATRIX_SIZE   EQU (4*4)

.data

; 4x4 character matrix.
charMatrix BYTE 4 DUP('x'), 0dh, 0ah
           BYTE 4 DUP('x'), 0dh, 0ah 
           BYTE 4 DUP('x'), 0dh, 0ah 
           BYTE 4 DUP('x'), 0dh, 0ah, 0dh, 0ah, 0
; Array of 26 alphabetic characters (5 vowels followed by the 21 consonants).
alphabet   BYTE 'A', 'E', 'I', 'O', 'U', 'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 
                'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z'

.code

;---------------------------------------------------
; Bounded random number generator. Returns randomly 
; generated number falling between lowerBound (ebx) 
; and upperBound (eax). Number returned in eax.
;---------------------------------------------------
BoundedRandomRange PROC 

	neg  ebx                    ; Negate upper bound.
	add  eax, ebx               ; range = lower + (-upper).
	call RandomRange            ; Get a random int.
	sub  eax, ebx               ; n = n - (-upper).
	ret                         ; Return in eax.

BoundedRandomRange ENDP

;---------------------------------------------------
; Returns a randomly generated character with a 50%
; frequency for vowels and consanants. The ASCII 
; character code returned in eax.
;---------------------------------------------------
getCharacter PROC USES ebx esi

	mov  eax, 2	            ; Get random int (0-1).
	call RandomRange
	test eax, 1                 ; Test for 50-50 frequency.
	jz @F

	mov  ebx, 0                 ; Select a vowel (0-4).
	mov  eax, 5                 ; Upper bound of random int.
	jmp  fetch

@@:
	mov  ebx, 5                 ; Select a consonant (5-25)
	mov  eax, 26                ; Upper bound of random int.

fetch:
	call BoundedRandomRange     ; Get respective random int (eax-ebx range).
	lea  esi, BYTE PTR alphabet ; Load array of characters.
	mov  al, BYTE PTR [esi+eax] ; Retrieve a charater, return in eax. 
	ret

getCharacter ENDP

;---------------------------------------------------
; Create our 4x4 character matrix.
;---------------------------------------------------
createMatrix PROC USES ebx ecx esi matrix:DWORD

	mov  esi, matrix            ; Put address of matrix into esi.
	mov  ecx, MATRIX_SIZE       ; Loop counter = 16 (4*4) characters.
	xor  ebx, ebx               ; Zeroize matrix index.
	jmp  L3                     ; Jump to start.

L1:
	test ecx, 3                 ; Every 4th character?
	jnz  L2                     ; Nope.
	add  ebx, 3                 ; Advance to next line.
	jmp  L3

L2:
	inc  ebx                    ; Advance 1 character.

L3:
	call getCharacter           ; Get a random character.
	mov  BYTE PTR[esi+ebx], al  ; Store in matrix.
	loop L1                     ; Repeat until ecx==0.

	ret

createMatrix ENDP

;---------------------------------------------------
; Program entry point.
;---------------------------------------------------
main PROC

	call Clrscr                 ; Clear console screen.
	call Randomize	            ; Seed random number generator.
	mov  ecx, NUMBER_ARRAYS     ; Create demonstration matrices.

@@:
	INVOKE createMatrix, OFFSET charMatrix
	mov  edx, OFFSET charMatrix ; Load edx with message addess.
	call WriteString            ; Call Irvine's WriteString function.
	loop @B

	exit

main ENDP
END main
