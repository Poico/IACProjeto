; Main.asm - Entry point and main code file

	PLACE 0
entry:
	; stack setup
	MOV SP, stack_top
	
	CALL IT_SetupInterrupts
	CALL IT_DisableGameInterrupts
	
	CALL MD_InitMedia
	CALL MAN_MainMenu
	
	CALL TL_InitTetraLogic
	
	
	
poll_loop:
	CALL KB_PollKey
	JMP poll_loop
	
end:
	JMP end
	

; includes
#include:lib/Interrupts.asm
#include:lib/MediaDrive.asm
#include:lib/Manager.asm
#include:lib/TetraLogic.asm
#include:lib/keyboard.asm

; stack
	PLACE 3800H
	STACK 07FEH
	PLACE 3FFEH
stack_top:
