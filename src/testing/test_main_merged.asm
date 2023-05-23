;test_main.asm - Random testing

PLACE 0
entry:
	MOV SP, stack_top

	MOV R1, key_press_handlers
	MOV R2, key_hold_handlers
	
get_key_loop:
	CALL KB_GetKey
	JEQ get_key_loop_end
	SHL R0, 1
	
	CMP R0, 0FFFFH
	JEQ get_key_loop_end
	
get_key_loop_hold:
	MOV R3, [R2 + R0]
	CMP R3, 0
	JEQ get_key_loop_press
	CALL R3
	
get_key_loop_press:
	MOV R3, [last_key]
	CMP R0, R3
	JEQ get_key_loop_end
	MOV R3, [R1 + R0]
	CMP R3, 0
	JEQ get_key_loop_end
	CALL R3
	
get_key_loop_end:
	MOV [last_key], R0
	JMP get_key_loop



end:
	JMP end

; keyboard.asm - Keyboard interfacing functions

_KB_KEYO	EQU 0C000H ; write to test
_KB_KEYI	EQU 0E000H ; read to check

;returns first pressed key in R0
KB_GetKey:
	PUSH R1 	; keyboard output pointer (write test)
	PUSH R2 	; keyboard input pointer (read key)
	PUSH R3 	; current bit for test
	PUSH R4 	; test bit shift counter
	PUSH R5		; bit mask & R0 shift counter

	MOV R1, _KB_KEYO
	MOV R2, _KB_KEYI
	MOV R3, 1
	XOR R4, R4
	MOV R5, 0FH
	
_KB_GetKey_loop:
	MOVB [R1], R3		; put test bit
	MOVB R0, [R2]		; read mask
	AND R0, R5			; mask first 4 bits
	CMP R0, 0			; MOVB doesn't affect flags
	JNE _KB_GetKey_dec	; found a key press
	SHL R3, 1			; shift test bit
	ADD R4, 1			; increment shift counter
	CMP R4, 4			; check loop end (4 bit shifts)
	JNE _KB_GetKey_loop ; repeat loop
	MOV R0, 0FFFFH		; -1 for empty
	JMP _KB_GetKey_end
	
_KB_GetKey_dec: 		; decode
	XOR R5, R5			; R5 = 0
	
_KB_GetKey_dlp:			; get bit position
	ADD R5, 1			; R5++
	SHR R0, 1			; R0 >>= 1
	JNE _KB_GetKey_dlp	; while (R0) goto _KB_GetKey_dlp

_KB_GetKey_df:
	SUB R5, 1			; R5-- (it's in [1,4])
	SHL R4, 2			; R0 = (R4 << 2) | R5
	OR R5, R4
	MOV R0, R5
	
_KB_GetKey_end:
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET

;returns non-zero in R1 if the key specified in R0 is pressed
KB_IsKeyPressed:
	MOV R1, R0
	CALL KB_GetKey
	CMP R0, R1
	MOV R1, R0
	JEQ _KB_IsKeyPressed_end
	XOR R1, R1
	
_KB_IsKeyPressed_end:
	RET
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
	PUSH R1
	MOV R1, _BC_HexOut	; Display pointer
	MOV [R1], R0		; Write value
	POP R1
	RET

key_3_hold:
	PUSH R0
	MOV R0, 0013H
	CALL BC_WriteToDisp
	POP R0
	RET
	
key_a_hold:
	PUSH R0
	PUSH R1
	MOV R0, [counterH]
	ADD R0, 1
	MOV [counterH], R0
	SHL R0, 8
	MOV R1, 001AH
	OR R0, R1
	CALL BC_WriteToDisp
	POP R1
	POP R0
	RET
	
key_b_press:
	PUSH R0
	PUSH R1
	MOV R0, [counter]
	ADD R0, 1
	MOV [counter], R0
	SHL R0, 8
	MOV R1, 002BH
	OR R0, R1
	CALL BC_WriteToDisp
	POP R1
	POP R0
	RET

key_press_handlers:
	WORD 	0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, key_b_press, 0, 0, 0, 0

key_hold_handlers:
	WORD	0, 0, 0, key_3_hold, 0, 0, 0, 0,
			0, 0, key_a_hold, 0, 0, 0, 0, 0
			
last_key:
	WORD 0FFFFH
	
counter:
	WORD 0
	
counterH:
	WORD 0

PLACE 3800H
STACK 07FEH
PLACE 3FFEH
stack_top:
