; Interrupts.asm - Interrupt setup and handlers

_IT_interrupt_vectors:
	WORD _IT_INT0, _IT_INT1, _IT_INT2, _IT_INT3,
		_IT_EXCESSO, _IT_DIV0, _IT_COD_INV, _IT_D_DESALINHADO, _IT_I_DESALINHADO

IT_SetupInterrupts:
	PUSH R0
	PUSH R1
	MOV BTE, _IT_interrupt_vectors	; load interrupt vector table
	MOV R0, RE
	MOV R1, 0FCFFH					; Clear TV & TD
	AND R0, R1
	MOV R1, 000F8H					; Set IE and IE#
	MOV RE, R0
	POP R1
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
