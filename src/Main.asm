; Main.asm - Entry point and main code file

	PLACE 0
entry:
	; stack 
end:
	JMP end
	

; includes
#include:lib/Interrupts.asm
#include:lib/keyboard.asm
#include:lib/MediaDrive.asm
#include:lib/RNG.asm
#include:lib/ScoreBar.asm

; stack
	PLACE 3800H
	STACK 07FEH
	PLACE 3FFEH
stack_top:
