; BCD.asm - Binary Coded Decimal library

_BC_HexOut EQU 0A000H

;returns value of R0 in R1 as BCD
BC_ToBCD:
	PUSH R0
					; Build BCD directly to R1
	PUSH R2			; Remainder divider
	PUSH R3			; Remainder store
	PUSH R4			; Iter counter
	
	XOR R1, R1		; Clear output
	MOV R2, 10000	; Initialize clamp divider
	MOD R0, R2		; Clamp input to allowed values
	
	MOV R2, 10		; Initialize divider
	MOV R4, 4		; Initialize counter
	
	
_BC_ToBCD_loop:
	SHR R1, 4		; Shift output to clear space
	MOV R3, R0		; Copy input
	MOD R3, R2		; Get %10
	SHL R3,	12		; Shift value to highest 4 bits
	ADD R1, R3		; Add to output
	DIV R0, R2		; Divide (shift) input
	SUB R4, 1		; Decrement counter
	JNZ _BC_ToBCD_loop
	
_BC_ToBCD_end:
	POP R4
	POP R3
	POP R2
	POP R0
	RET
	
	
;Write R0 to hexadecimal display
BC_WriteToDisp:
	PUSH R0
	MOV R0, _BC_HexOut	; Display pointer
	MOV [R0], R1		; Write value
	POP R0
	RET
