; Interrupts.asm - Interrupt setup and handlers
; External clocks:
; 0 - draw
; 1 - animation
; 2 - gravity
; 3 - input

_IT_CLR_TV_TD 	EQU 0FCFFH	; Bitmask to clear TV & TD
_IT_SET_INTS 	EQU 000F8H	; Bitmask to set IE and IE# (0-3)
_IT_CLR_GINTS 	EQU 0FF8FH	; Bitmask to clear game interrupts IE# (0-2)
_IT_SET_GINTS	EQU 00070H	; Bitmask to set game interrupts IE# (0-2)

_IT_interrupt_vectors:
	WORD _IT_INT0, _IT_INT1, _IT_INT2, _IT_INT3,
		_IT_EXCESSO, _IT_DIV0, _IT_COD_INV, _IT_D_DESALINHADO, _IT_I_DESALINHADO

IT_SetupInterrupts:
	PUSH R0
	PUSH R1
	
	MOV BTE, _IT_interrupt_vectors	; load interrupt vector table
	MOV R0, RE
	MOV R1, _IT_CLR_TV_TD			; Clear TV & TD
	AND R0, R1
	MOV R1, _IT_SET_INTS			; Set IE and IE# (0-3)
	MOV RE, R0
	
	POP R1
	POP R0
	RET
	
IT_DisableGameInterrupts:
	PUSH R0
	MOV R0, _IT_CLR_GINTS			; Load bitmask
	AND RE, R0						; Clear interrupt bits
	POP R0
	RET
	
IT_EnableGameInterrupts:
	PUSH R0
	MOV R0, _IT_SET_GINTS			; Load bitmask
	OR RE, R0						; Set interrupts bits
	POP R0
	RET
	
_IT_INT0:
_IT_drawINT:
	RFE
	
_IT_INT1:
_IT_animationINT:
	RFE
	
_IT_INT2:
_IT_gravityINT:
	RFE
	
_IT_INT3:
_IT_inputINT:
	RFE
	
_IT_EXCESSO:
_IT_DIV0:
_IT_Discard:
	RFE
	
_IT_COD_INV:
	RFE
	
_IT_D_DESALINHADO:
	RFE
	
_IT_I_DESALINHADO:
	RFE
