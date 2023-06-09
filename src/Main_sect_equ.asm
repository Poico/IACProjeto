; *********************************************************************************
; * Projeto IAC 2022/23 - IST-UL - Versão Intermédia
; * Alunos: Rodrigo Gomes (106644) Diogo Diniz (106196) Tomás Antunes (106265)
; *********************************************************************************
;---Constants------
MD_Commands EQU						6000H
MD_Command_ClearScreen EQU			MD_Commands+02H
MD_Command_AutoMov EQU				MD_Commands+10H
MD_Command_RemoveWarning EQU		MD_Commands+40H
MD_Command_SetX EQU					MD_Commands+0CH
MD_Command_SetY EQU					MD_Commands+0AH
MD_Command_Draw EQU					MD_Commands+12H
MD_Command_SetBackground EQU		MD_Commands+42H
MD_Command_PlayVideoMusic EQU		MD_Commands+5AH
MD_Command_PlayVideoMusicLoop EQU	MD_Commands+5CH
MD_Command_PauseVideoMusic EQU		MD_Commands+5EH
MD_Command_ContinueVideoMusic EQU	MD_Commands+60H
MD_Command_StopsVideoMusic EQU		MD_Commands+66H

_MD_Memmory EQU	8000H
_MD_Width EQU 	32
_MD_Height EQU	64

_BC_HexOut EQU 0A000H

_SB_WIDTH		EQU 32
_SB_HEIGHT		EQU 64
_SB_BWIDTH 		EQU 4
_SB_BHEIGHT		EQU 12
_SB_CORNER_X	EQU 25
_SB_CORNER_Y	EQU 18
_SB_MAX			EQU 100

_TL_BoardArea EQU	200

_MAN_MENU_BACKGROUND EQU	0
_MAN_PLAY_BACKGROUND EQU	1
_MAN_PAUSE_BACKGROUND EQU	2
_MAN_WIN_BACKGROUND	EQU		3
_MAN_LOSE_BACKGROUND EQU	4

_MAN_MUSIC_ID EQU			0
_MAN_LNE_CLR_ID EQU			1

_KB_KEYO	EQU 0C000H ; write to test
_KB_KEYI	EQU 0E000H ; read to check

_IT_CLR_TV_TD 	EQU 0FF3FH	; Bitmask to clear TV & TD
_IT_SET_INTS 	EQU 01100H	; Bitmask to set IE and IE# (0-3)
_IT_CLR_GINTS 	EQU 0F1FFH	; Bitmask to clear game interrupts IE# (0-2)
_IT_SET_GINTS	EQU 00E00H	; Bitmask to set game interrupts IE# (0-2)

