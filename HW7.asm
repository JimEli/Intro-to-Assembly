; Homework #7
; James Eli
; 9/2/2018
;
; FPU code.
;

INCLUDE Irvine32.inc

.data

B real8 7.8
M real8 7.1
N real8 3.1
P real8 ?

.code

main PROC

	; double P = -M * (N + B);
	fld   M            ; Push M on stack
	fchs               ; Change sign
	fld   N            ; Push N on stack
	fadd  B            ; N + B
	fmulp st(1), st(0) ;  	
	fstp  P            ; Put result in P

	exit
	
main ENDP
END main
