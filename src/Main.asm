; Main.asm - Entry point and main code file

#include:lib/Header.asm

	PLACE 0
entry:
	; stack setup
	MOV SP, stack_top
	
	CALL IT_SetupInterrupts
	CALL IT_DisableGameInterrupts
	
	CALL MD_InitMedia
	CALL MAN_MainMenu
	
	CALL TL_InitTetraLogic
	
	CALL MAN_StartBackgroundMusic
	
	
	
poll_loop:
	CALL KB_PollKey
	CALL KB_DoHandles
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
