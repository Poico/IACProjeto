; Main.asm - Entry point and main code file

#include:lib/Header.asm

#section:data
; stack
	PLACE 3800H
	STACK 0400H
stack_top:

	PLACE 1000H ;Hard bind data to this address (section support)

#section:text
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
	CALL MD_ClearScreen
	
	
;Application loop to execute code
;Interrupts signal functions to execute or return early
exec_loop:
	CALL KB_PollKey ; Constantly poll keyboard
	CALL KB_DoHandles 		; Do handles if flag is set
	CALL SB_DrawSB			; Draw if flag is set
	CALL TL_DrawTetraLogic	; Draw if flag is set
	CALL TL_TetraLogicGrav	; Update if flag is set
	JMP exec_loop
	
end:
	JMP end
	

; includes
#include:lib/Interrupts.asm
#include:lib/MediaDrive.asm
#include:lib/Manager.asm
#include:lib/TetraLogic.asm
#include:lib/keyboard.asm
