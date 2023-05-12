; Keyboard.asm - Keyboard interfacing functions

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
