; Main.asm - Entry point and main code file

	PLACE 0
entry:
	; stack setup
	MOV SP, stack_top
	
	CALL IT_SetupInterrupts
	
	CALL MD_InitMedia
	MOV R0, 0					; Load game background
	CALL MD_SetBack
	
	CALL TL_ResetBoard
	
	
	
poll_loop:
	CALL KB_PollKey
	JMP poll_loop
	
end:
	JMP end
	

; includes
#include:lib/Interrupts.asm
#include:lib/keyboard.asm
#include:lib/MediaDrive.asm
#include:lib/TetraLogic.asm

; stack
	PLACE 3800H
	STACK 07FEH
	PLACE 3FFEH
stack_top:
