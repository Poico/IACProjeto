; keyboard.asm - Keyboard interfacing functions

; includes
#include:Manager.asm

#section:equ
_KB_KEYO	EQU 0C000H ; write to test
_KB_KEYI	EQU 0E000H ; read to check

#section:data
_KB_Press_Handles:
	;		0							1					2		3
	WORD	MAN_BackgroundMusicClick,	TL_RotateTetra,		0,		0,
	;		4						5	6					7
			TL_MoveTetraLeft,		0,	TL_MoveTetraRight,	0,
	;		8		9				A	B
			0,		TL_SlamTetra,	0,	0,
	;		C		D				E	F
			0, 		MAN_PauseClick,	0, 	MAN_PlayMenu
			
_KB_Hold_Handles:
	;		0		1		2		3
	WORD	0,		0,		0,		0,
	;		4		5		6		7
			0,		0,		0,		0,
	;		8		9		A		B
			0,		0,		0,		0,
	;		C		D		E		F
			0, 		0,		0, 		0

_KB_LastKeyPressed:
	WORD 0
	
_KB_NextKeyPressHandle:
	WORD 0
_KB_NextKeyHoldHandle:
	WORD 0
	
_KB_HandleFlag:
	WORD 0

#section:text
; Returns first pressed key in R0
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


; Returns non-zero in R1 if the key specified in R0 is pressed
KB_IsKeyPressed:
	MOV R1, R0
	CALL KB_GetKey
	CMP R0, R1
	MOV R1, R0
	JEQ _KB_IsKeyPressed_end
	XOR R1, R1
	
_KB_IsKeyPressed_end:
	RET


; Polls keyboard and sets up the key
KB_PollKey:
	PUSH R0
	PUSH R1						; Press_Handles base pointer
	PUSH R2						; Hold_Handles base pointer
	PUSH R3						; Auxiliar
	
	MOV R1, _KB_Press_Handles	; Load pointers
	MOV R2, _KB_Hold_Handles
	
_KB_PollKey_start:
	CALL KB_GetKey
	
	CMP R0, 0FFFFH					; Check for empty key
	JEQ _KB_PollKey_end				; Skip if empty
	
	SHL R0, 1						; Multiply by 2 (word size)
	
_KB_PollKey_hold:
	MOV R3, [_KB_NextKeyHoldHandle] ; Check for handle already set
	TEST R3, R3						; (Update Z flag)
	JNE _KB_PollKey_press			; Ignore if handle is set
	
	MOV R3, [R2 + R0]				; Get handle
	MOV [_KB_NextKeyHoldHandle], R3	; Set next handle

_KB_PollKey_press:
	MOV R3, [_KB_NextKeyPressHandle]; Check for handle already set
	TEST R3, R3						; (Update Z flag)
	JNE _KB_PollKey_end				; Ignore if handle is set
	
	MOV R3, [_KB_LastKeyPressed]	; Check if key pressed changed
	CMP R0, R3
	JEQ _KB_PollKey_end				; Skip if press didn't change
	
	MOV R3, [R1 + R0]				; Get handle
	MOV [_KB_NextKeyPressHandle], R3; Set next handle
	
_KB_PollKey_end:
	MOV [_KB_LastKeyPressed], R0	; Update last key pressed

	POP R3
	POP R2
	POP R1
	POP R0
	RET

KB_EnableHandle:
	PUSH R0
	MOV R0, 1
	MOV [_KB_HandleFlag], R0
	POP R0
	RET

; Polls keyboard and executes assigned functions
KB_DoHandles:
	PUSH R0	; Handle pointer
	
	MOV R0, [_KB_HandleFlag]
	TEST R0, R0
	JEQ _KB_DoHandles_end
	XOR R0, R0
	MOV [_KB_HandleFlag], R0		; Reset handle flag
	
_KB_DoHandles_hold:
	MOV R0, [_KB_NextKeyHoldHandle]	; Load handle pointer
	TEST R0, R0						; (Update Z flag)
	JEQ _KB_DoHandles_press			; Skip if NULL
	CALL R0							; Call handle

_KB_DoHandles_press:
	MOV R0, [_KB_NextKeyPressHandle]; Load handle pointer
	TEST R0, R0						; (Update Z flag)
	JEQ _KB_DoHandles_reset			; Skip if NULL
	CALL R0							; Call handle
	
_KB_DoHandles_reset:
	XOR R0, R0						; Reset handle pointers
	MOV [_KB_NextKeyHoldHandle], R0
	MOV [_KB_NextKeyPressHandle], R0

_KB_DoHandles_end:
	POP R0
	RET
