; Manager.asm

#include:keyboard.asm
#include:Interrupts.asm
#include:MediaDrive.asm
#include:TetraLogic.asm
#include:ScoreBar.asm

#section:equ
_MAN_MENU_BACKGROUND EQU	0
_MAN_PLAY_BACKGROUND EQU	1
_MAN_PAUSE_BACKGROUND EQU	2
_MAN_WIN_BACKGROUND	EQU		3
_MAN_LOSE_BACKGROUND EQU	4

_MAN_MUSIC_ID EQU			0
_MAN_LNE_CLR_ID EQU			1

_MAN_RemoveWarningCmd EQU	6040H

#section:data
_MAN_ToggleGame:
	WORD 0
_MAN_TogglePause:
	WORD 0
_MAN_ToggleMusic:
	WORD 1

#section:text
;Sets Main Menu Background
MAN_MainMenu:
	PUSH R0
	
	XOR R0, R0
	MOV [_MAN_ToggleGame], R0
	MOV R0, _MAN_MENU_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	
	POP R0
	RET
	
;Sets Play Menu Background
MAN_PlayMenu:
	PUSH R0
	
	MOV R0, 1
	MOV [_MAN_ToggleGame], R0
	MOV R0, _MAN_PLAY_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	CALL SB_ResetScore
	CALL TL_InitTetraLogic
	CALL IT_EnableGameInterrupts
	
	POP R0
	RET

	
;Sets Pause Menu Background
MAN_PauseClick:
	PUSH R0
	PUSH R1
	
	
	MOV R0, [_MAN_ToggleGame]
	CMP R0, 0
	JEQ _MAN_PauseClick_end
	MOV R1, [_MAN_TogglePause]
	CMP R1, 0
	JEQ _MAN_Pause
	
_MAN_UnPause:
	MOV R0, _MAN_PLAY_BACKGROUND
	CALL MD_SetBack ; Call Function Set
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
	CALL MD_ClearScreen
	
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
	
	MOV R0, _MAN_LNE_CLR_ID
	CALL MD_Play
	
	POP R0
	RET


;Plays Background Music on Loop 
MAN_BackgroundMusicClick:
	PUSH R0 ; ID for the Music
	PUSH R1 
	
	MOV R1, [_MAN_ToggleMusic]
	CMP R1, 0
	JEQ _MAN_PlayMusic
	
_MAN_StopMusic:
	MOV R0, _MAN_MUSIC_ID
	CALL MD_Pause ; Call Function Set
	XOR R0, R0
	MOV [_MAN_ToggleMusic], R0
	JMP _MAN_BackgroundMusicClick_end
	
_MAN_PlayMusic:
	MOV R0, _MAN_MUSIC_ID
	CALL MD_Unpause ; Call Function Set
	MOV R0, 1
	MOV [_MAN_TogglePause], R0

_MAN_BackgroundMusicClick_end:
	POP R1
	POP R0
	RET


;Changes background to win screen
MAN_ShowWinScreen:
	PUSH R0
	XOR R0, R0
	MOV [_MAN_ToggleGame], R0
	MOV R0, _MAN_WIN_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	CALL IT_DisableGameInterrupts
	CALL MD_ClearScreen
	POP R0
	JMP _MAN_StuckLoop
	RET ;Here to conserve structure, never reached

;Changes background to lose screen
MAN_ShowLoseScreen:
	PUSH R0
	XOR R0, R0
	MOV [_MAN_ToggleGame], R0
	MOV R0, _MAN_LOSE_BACKGROUND
	CALL MD_SetBack ; Call Function Set
	CALL IT_DisableGameInterrupts
	CALL MD_ClearScreen
	JMP _MAN_StuckLoop
	
_MAN_StuckLoop:
	; Keep interrupts for keyboard
	CALL KB_PollKey
	CALL KB_DoHandles
	MOV R0, [_MAN_ToggleGame]
	CMP R0, 0
	JEQ _MAN_StuckLoop ;infinite loop for win/lose condition
	POP R0
	RET

; "Exit" function
MAN_Exit:
	MOV R0, _MAN_MUSIC_ID 				
	CALL MD_Stop 						; Stop music
	CALL MD_ClearScreen 				; Clear screen
	MOV [_MAN_RemoveWarningCmd],R0		; Clear background
	DI
_MAN_Exit_loop:
	JMP _MAN_Exit_loop
