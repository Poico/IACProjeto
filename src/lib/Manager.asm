; Manager.asm

#include:Interrupts.asm
#include:MediaDrive.asm

#section:equ
_MAN_MENU_BACKGROUND EQU	0
_MAN_PLAY_BACKGROUND EQU	1
_MAN_PAUSE_BACKGROUND EQU	2
_MAN_WIN_BACKGROUND	EQU		3
_MAN_LOSE_BACKGROUND EQU	4

#section:data
_MAN_TogglePause:
	WORD 0

_MAN_ToggleMusic:
	WORD 0

#section:text
;Sets Main Menu Background
MAN_MainMenu:

	PUSH R0
	
	MOV R0, _MAN_MENU_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	
	POP R0
	
	RET
	
;Sets Play Menu Background
MAN_PlayMenu:
	PUSH R0
	
	MOV R0, _MAN_PLAY_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	CALL IT_EnableGameInterrupts
	
	POP R0
	RET

	
;Sets Pause Menu Background
MAN_PauseClick:
	PUSH R0
	PUSH R1
	
	MOV R1, [_MAN_TogglePause]
	CMP R1 , 0
	JEQ _MAN_Pause
	
_MAN_UnPause:
	CALL MAN_PlayMenu
	MOV R0, 0
	MOV [_MAN_TogglePause], R0
	CALL IT_EnableGameInterrupts
	JMP _MAN_PauseClick_end
	
_MAN_Pause:
	MOV R0, _MAN_PAUSE_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	MOV R0, 1
	MOV [_MAN_TogglePause], R0
	CALL IT_DisableGameInterrupts
	
_MAN_PauseClick_end:
	POP R1
	POP R0
	RET

MAN_StartBackgroundMusic:
	PUSH R0
	MOV R0, 0 ;ID of Background Music
	CALL MD_Loop ;function to play music on loop 
	
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
MAN_BackgroundMusicClick:
	
	PUSH R0 ; ID for the Music
	PUSH R1 
	
	MOV R1 , [_MAN_ToggleMusic]
	CMP R1 , 0
	JNZ _MAN_PlayMusic
_MAN_StopMusic:
	MOV R0, 0
	CALL MD_Pause
	MOV R0, 1
	MOV [_MAN_ToggleMusic], R0
	JMP _MAN_BackgroundMusicClick_end
	
_MAN_PlayMusic:
	MOV R0 , 0 
	CALL MD_Unpause ; Call Function Set
	MOV [_MAN_TogglePause], R0

_MAN_BackgroundMusicClick_end:
	POP R1
	POP R0
	RET


;Changes background to win screen
MAN_ShowWinScreen:
	PUSH R0
	MOV R0, _MAN_WIN_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	CALL IT_DisableGameInterrupts
	CALL MD_ClearScreen
	CALL SB_DisableDrawFlag
	CALL TL_DisableDrawFlag
	CALL TL_DisableGravityFlag
	POP R0
	JMP _MAN_WinStuckLoop
	RET ;Here to conserve structure, never reached
	
_MAN_WinStuckLoop:
	DI
	JMP _MAN_WinStuckLoop ;infinite loop for win condition

;Changes background to lose screen
MAN_ShowLoseScreen:
	PUSH R0
	MOV R0, _MAN_LOSE_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	CALL IT_DisableGameInterrupts
	CALL MD_ClearScreen
	CALL SB_DisableDrawFlag
	CALL TL_DisableDrawFlag
	CALL TL_DisableGravityFlag
	POP R0
	JMP _MAN_LoseStuckLoop
	RET ;Here to conserve structure, never reached
	
_MAN_LoseStuckLoop:
	DI
	JMP _MAN_LoseStuckLoop ;infinite loop for lose condition
