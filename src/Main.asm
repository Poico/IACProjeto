; Main.asm - Entry point and main code file

	PLACE 0
entry:
	; stack 
	MOV SP, stack_top
	
	CALL IT_SetupInterrupts
	CALL MD_InitMedia
	MOV R0, 0
	CALL MD_SetBack
	
poll_loop:
	CALL KB_PollKey
	JMP poll_loop
	
end:
	JMP end
	

; includes
#include:lib/Interrupts.asm
#include:lib/keyboard.asm
#include:lib/MediaDrive.asm

; stack
	PLACE 3800H
	STACK 07FEH
	PLACE 3FFEH
stack_top:
