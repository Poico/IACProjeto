;keyboard.asm

;returns key in R0
get_key:
	PUSH R1 	; keyboard output pointer (write test)
	PUSH R2 	; keyboard input pointer (read key)
	PUSH R3 	; current bit for test
	PUSH R4 	; test bit shift counter
	PUSH R5		; bit mask & R0 shift counter

	MOV R1, KEYO
	MOV R2, KEYI
	MOV R3, 1
	XOR R4, R4
	MOV R5, 0FH
	
get_key_loop:
	MOVB [R1], R3		; put test bit
	MOVB R0, [R2]		; read mask
	AND R0, R5			; mask first 4 bits
	CMP R0, 0			; MOVB doesn't affect flags
	JNE get_key_dec		; found a key press
	SHL R3, 1			; shift test bit
	ADD R4, 1			; increment shift counter
	CMP R4, 4			; check loop end (4 bit shifts)
	JNE get_key_loop 	; repeat loop
	MOV R0, 0FFFFH		; -1 for empty
	JMP get_key_end
	
get_key_dec: 			; decode
	XOR R5, R5
	
get_key_dlp:
	ADD R5, 1			; R5++
	SHR R0, 1			; R0 >>= 1
	JNE get_key_dlp

get_key_df:
	SUB R5, 1			; R5-- (it's in [1,4])
	SHL R4, 2			; R0 = (R4 << 2) | R5
	OR R5, R4
	MOV R0, R5
	
get_key_end:
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET

