; Manager.asm

#include:Interrupts.asm
#include:MediaDrive.asm

_MAN_TogglePause:
	WORD 0

;Sets Main Menu Background
MAN_MainMenu:

	PUSH R0
	
	MOV R0 , 0 ; Set MainMenuBackground (ID-0)
	CALL MD_SetBack ; Call Function Set
	
	POP R0
	
	RET
	
;Sets Play Menu Background
MAN_PlayMenu:

	PUSH R0
	
	MOV R0 , 1 ; Set PlayMenuBackground (ID-1)
	CALL MD_SetBack ; Call Function Set
	
	POP R0
	
	RET
	
;Sets Pause Menu Background
MAN_PauseClick:

	PUSH R0
	PUSH R1
	
	MOV R1 , _MAN_TogglePause
	MOV R1, [R1]
	CMP R1 , 0
	JNZ _MAN_Pause
	
_MAN_UnPause:
	CALL MAN_PlayMenu
	JMP _MAN_PauseClick_end
	
_MAN_Pause
	MOV R0 , 2 ; Set PlayPauseMenu (ID-2)
	CALL MD_SetBack ; Call Function Set
	CALL IT_DisableGameInterrupts
	
	
_MAN_PauseClick_end:
	POP R1
	POP R0
	
	RET



;Plays One Time Sound of the Line Clear
MAN_LineCleared:

	PUSH R0 ; ID for the Sound
	
	MOV R0 , 1 ; Set LineClearedSound (ID-1)
	CALL MD_Play
	
	POP R0
	
	RET

;Plays Background Music on Loop 
MAN_BackgroundMusic:

	PUSH R0 ; ID for the Music
	
	MOV R0, 0 ; Set BackgroundMusic (ID-0)
	CALL MD_Loop
	
	POP R0
	
	RET

