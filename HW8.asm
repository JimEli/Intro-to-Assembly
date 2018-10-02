; Homework #8
; James Eli
; 9/3/2018
;
; BubbleSort.
;

INCLUDE Irvine32.inc

.data

Array     DWORD 1
ArraySize DWORD 4

.code

BubbleSort PROC USES eax ecx esi, pArray:DWORD, Count:DWORD

	mov  ecx, Count
	dec  ecx
L1:
	push ecx
	mov  esi, pArray
L2:
	mov  eax, [esi]
	cmp  [esi+4], eax
	jg   L3
	xchg eax, [esi+4]
	mov  [esi], eax
L3:
	add  esi, 4
	loop L2

	pop  ecx
	loop L1
L4:
	ret
	
BubbleSort ENDP

Delimiters LABEL BYTE
FORC code,<@#$%^&*!<!>>
	BYTE "&code"
ENDM

main PROC

	push ArraySize
	push OffSET Array
	call BubbleSort
	exit

main ENDP
END main
