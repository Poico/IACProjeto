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

_MAN_MENU_BACKGROUND EQU	0
_MAN_PLAY_BACKGROUND EQU	1
_MAN_PAUSE_BACKGROUND EQU	2
_MAN_WIN_BACKGROUND	EQU		3
_MAN_LOSE_BACKGROUND EQU	4

_KB_KEYO	EQU 0C000H ; write to test
_KB_KEYI	EQU 0E000H ; read to check

_IT_CLR_TV_TD 	EQU 0FF3FH	; Bitmask to clear TV & TD
_IT_SET_INTS 	EQU 01F00H	; Bitmask to set IE and IE# (0-3)
_IT_CLR_GINTS 	EQU 0F1FFH	; Bitmask to clear game interrupts IE# (0-2)
_IT_SET_GINTS	EQU 00E00H	; Bitmask to set game interrupts IE# (0-2)

_TL_BoardArea EQU	200

; stack
	PLACE 3800H
	STACK 0400H
stack_top:

	PLACE 1000H ;Hard bind data to this address (section support)


MD_TestPalette:
;	0	  1	  2	  3	  4
WORD 0FFFFH,00000H,0F000H,0FF00H,0F0DFH
MD_TestSprite:
WORD 00007H,00020H
,00000H,01100H,01111H,01111H,01111H,01111H,01111H
,02220H,01100H,00111H,00000H,00000H,01111H,01111H
,00020H,01102H,00011H,03333H,00333H,01110H,01111H
,02220H,01100H,03001H,03333H,03333H,01100H,01111H
,00020H,01102H,03300H,03333H,03333H,01003H,01111H
,02220H,01100H,03330H,03333H,03333H,01033H,01111H
,00000H,01100H,03330H,03333H,03333H,00033H,01000H
,02220H,01100H,04440H,04444H,03333H,03333H,01033H
,00020H,01102H,04440H,04444H,03334H,03333H,01033H
,02220H,01100H,04440H,04444H,03334H,03333H,01033H
,00020H,01102H,04440H,04444H,03334H,03333H,01033H
,00000H,01100H,04440H,04444H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,02200H,01100H,03330H,03333H,03333H,03333H,01033H
,00000H,01100H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,00033H,01000H
,02220H,01102H,03330H,03333H,03333H,01033H,01111H
,00020H,01102H,03330H,03333H,03333H,01033H,01111H
,00000H,01100H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,00000H,00000H,00000H,01000H,01111H
_MD_Glyphs:
;		0		1		2		3		4		5		6		7
WORD	07B6FH,	02492H,	073E7H,	079E7H,	049EDH,	079CFH,	07BCFH,	04927H,
;		8		9		A		B		C		D		E		F
		07BEFH,	049EFH,	05BEFH,	03AEBH,	0624EH,	03B6BH,	073CFH,	013CFH

_SB_DrawFlag:
	WORD 0

_SB_Color:
	WORD 0FF00H
	
_SB_Score:
	WORD 4

_MAN_TogglePause:
	WORD 0

_MAN_ToggleMusic:
	WORD 0

_KB_Press_Handles:
	;		0							1					2		3
	WORD	MAN_BackgroundMusicClick,	TL_RotateTetra,		0,		0,
	;		4						5	6					7
			TL_MoveTetraLeft,		0,	TL_MoveTetraRight,	0,
	;		8		9				A	B
			0,		TL_SlamTetra,	0,	0,
	;		C		D				E	F
			0, 		MAN_PauseClick,	0, 	MAN_PlayMenu
			
_KB_Hold_Handles:
	;		0		1		2		3
	WORD	0,		0,		0,		0,
	;		4		5		6		7
			0,		0,		0,		0,
	;		8		9		A		B
			0,		0,		0,		0,
	;		C		D		E		F
			0, 		0,		0, 		0

_KB_LastKeyPressed:
	WORD 0
	
_KB_NextKeyPressHandle:
	WORD 0
_KB_NextKeyHoldHandle:
	WORD 0
	
_KB_HandleFlag:
	WORD 0

_IT_interrupt_vectors:
	WORD 	_IT_INT0,		_IT_INT1,	_IT_INT2,		_IT_INT3,
			_IT_EXCESSO,	_IT_DIV0,	_IT_COD_INV,	_IT_D_DESALINHADO,	_IT_I_DESALINHADO


;this is where the RNG value is stored
RNG_ADDRESS:
WORD 01B1EH ;Starting value can be anything


_TL_TetraColors: WORD 0000H,	0FFF0H,		0FF00H,		0F5F8H,			0F0FFH,		0F00FH,		0FF80H,			0F70FH
_TL_Tetras: WORD	  0000H,	_TL_Square,	_TL_Z_Horz,	_TL_invZ_Horz,	_TL_I_Vert,	_TL_L_ANG0,	_TL_invL_ANG0,	_TL_T_ANG0
					;Master Block
					;NEXT SHAPE 	BL1X BL1Y BL2X BL2Y BL3X BL3Y BL4X BL4Y
_TL_Square: WORD 	_TL_Square,		0000,0000,0001,0000,0001,0001,0000,0001
			
_TL_Z_Horz: WORD 	_TL_Z_Vert,		0001,0001,0000,0000,0001,0000,0002,0001
_TL_Z_Vert: WORD 	_TL_Z_Horz,		0000,0001,0001,0000,0001,0001,0000,0002

_TL_invZ_Horz: WORD _TL_invZ_Vert,	0001,0001,0000,0001,0001,0000,0002,0000
_TL_invZ_Vert: WORD _TL_invZ_Horz,	0000,0001,0000,0000,0001,0001,0001,0002

_TL_I_Horz: WORD 	_TL_I_Vert,		0001,0000,0000,0000,0002,0000,0003,0000
_TL_I_Vert: WORD 	_TL_I_Horz,		0000,0001,0000,0000,0000,0002,0000,0003
		
_TL_L_ANG0: WORD 	_TL_L_ANG1,		0000,0001,0000,0000,0000,0002,0001,0002
_TL_L_ANG1: WORD 	_TL_L_ANG2,		0001,0001,0000,0001,0002,0001,0002,0000
_TL_L_ANG2: WORD 	_TL_L_ANG3,		0001,0001,0000,0000,0001,0000,0001,0002
_TL_L_ANG3: WORD 	_TL_L_ANG0,		0001,0000,0000,0000,0000,0001,0002,0000

_TL_invL_ANG0: WORD _TL_invL_ANG1,	0001,0001,0001,0000,0001,0002,0000,0002
_TL_invL_ANG1: WORD _TL_invL_ANG2,	0001,0000,0000,0000,0002,0000,0002,0001
_TL_invL_ANG2: WORD _TL_invL_ANG3,	0000,0001,0001,0000,0000,0000,0000,0002
_TL_invL_ANG3: WORD _TL_invL_ANG0,	0001,0001,0000,0001,0000,0000,0002,0001

_TL_T_ANG0: WORD 	_TL_T_ANG1,		0001,0001,0001,0000,0002,0001,0001,0002
_TL_T_ANG1: WORD 	_TL_T_ANG2,		0001,0001,0002,0001,0001,0002,0000,0001
_TL_T_ANG2: WORD 	_TL_T_ANG3,		0001,0001,0001,0002,0000,0001,0001,0000
_TL_T_ANG3: WORD 	_TL_T_ANG0,		0001,0001,0000,0001,0001,0000,0002,0001

_TL_MovingTetra:
	WORD
	;ID		next
	0000,	0000,
	0000,	0000, ;block 1
	0000,	0000, ;block 2
	0000,	0000, ;block 3
	0000,	0000 ;block 4

_TL_NextTetra:
	WORD 0000

_TL_Board:
	TABLE _TL_BoardArea
	
_TL_DrawFlag:
	WORD 0
_TL_GravFlag:
	WORD 0

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
; Interrupts.asm - Interrupt setup and handlers
; External clocks:
; 0 - draw
; 1 - animation/RNG
; 2 - gravity
; 3 - input

; includes
; ScoreBar.asm - Functions to draw an animated score bar

; MediaDrive.asm


;Input nothing
;Output nothing
;Clear screen and removes warning
MD_InitMedia:
	PUSH R0
	MOV R0,1
	MOV [MD_Command_AutoMov],R0;AutoMov enabled some draw call need this on
	MOV [MD_Command_ClearScreen],R0;clear screen(s)
	MOV [MD_Command_RemoveWarning],R0;remove warning
	POP R0
	RET

;Input nothing
;Output nothing
;Clear screen
MD_ClearScreen:
	MOV [MD_Command_ClearScreen],R0 ;clear screen(s)
	RET

;Input R0(Color)
;Output nothing
;Fills the background with a color
;[WARNING:TALK TO TEACHER ABOUT THE N-PIXEL THING]
;Best to not use this
MD_ColorBack:
	PUSH R1
	PUSH R2

	MOV R1,_MD_Width
	MOV R2,_MD_Height
	MUL R1,R2 ;Get Total Pixel Count
_MD_ColorBack_loop:
	MOV [MD_Command_Draw],R0 ;Draw And Move
	SUB R0,1
	CMP R0,0
	JNZ _MD_ColorBack_loop

	POP R2
	POP R1
	RET


;Input R0(X) R1(Y) R2(Color)
;Output nothing
;Draws a pixel
MD_DrawPixel:
	MOV [MD_Command_SetX],R0;Set X
	MOV [MD_Command_SetY],R1;Set Y
	MOV [MD_Command_Draw],R2;Draw
	RET

;Input R0(ID)
;Output nothing
;Sets Background
MD_SetBack:
	MOV [MD_Command_SetBackground],R0 ;Set Background with the adress of MediaCenter plus the command to set background
	RET

;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
;Output nothing
;Draws a rectagle
MD_DrawRect:
	PUSH R1 
	PUSH R3 
	PUSH R5 

_MD_DrawRect_height:
	MOV [MD_Command_SetX],R0;Set X
	MOV [MD_Command_SetY],R1;Set Y
	MOV R5,R2

_MD_DrawRect_width:
	MOV [MD_Command_Draw],R4;Draw
	SUB R5,1
	CMP R5,0
	JNZ _MD_DrawRect_width

	SUB R3,1
	ADD R1,1
	CMP R3,0
	JNZ _MD_DrawRect_height

	POP R5
	POP R3
	POP R1
	RET

;Input R0(X) R1(Y) R2(Sprite Adress) R3(Sprite Pallet)
;Output nothing
;Draws A Sprite From and Adress
MD_DrawSprite:
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10

	MOV R8,0FH;MASK
	MOV R4,[R2 + 0];get width
	MOV R5,[R2 + 2];get height
	ADD R2,4;set to the sheet area

_MD_DrawSpriteH_HeightLoop:
	MOV [MD_Command_SetX],R0;Set X
	MOV [MD_Command_SetY],R1;Set Y
	MOV R10,R4

_MD_DrawSprite_widthloop:
	MOV R6,[R2];get sheet

	;1 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Command_Draw],R9;Draw
	SHR R6,4;

	;2 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Command_Draw],R9;Draw
	SHR R6,4;

	;3 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Command_Draw],R9;Draw
	SHR R6,4;

	;4 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Command_Draw],R9;Draw

	ADD R2,2
	SUB R10,1
	CMP R10,0
	JNZ _MD_DrawSprite_widthloop
	
	ADD R1,1
	SUB R5,1
	CMP R5,0
	JNZ _MD_DrawSpriteH_HeightLoop

	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R2
	POP R1
	RET

;Input R0(X) R1(Y) R2(Color) R3(number)
;Output nothing
;Draws A Numberic Glyph From and Adress
MD_DrawHex:
	PUSH R1
	PUSH R3
	PUSH R4
	PUSH R6
	PUSH R7
	PUSH R8

	MOV R6,_MD_Glyphs
	SHL R3,1
	MOV R4,[R3 + R6];load GLYPHS
	MOV R6,0000H
	MOV R8,5
_MD_DrawHex_HeightLoop:
	MOV [MD_Command_SetX],R0;Set X
	MOV [MD_Command_SetY],R1;Set Y
	MOV R7,3
_MD_DrawHex_WidthLoop:
	SHR R4,1
	JNC _MD_DrawHex_NoCarry
	MOV [MD_Command_Draw],R2;Draw Color
	JMP _MD_DrawHex_Move
_MD_DrawHex_NoCarry:
	MOV [MD_Command_Draw],R6;Draw nothing
_MD_DrawHex_Move:
	SUB R7,1
	CMP R7,0
	JNZ _MD_DrawHex_WidthLoop
	ADD R1,1
	SUB R8,1
	CMP R8,0
	JNZ _MD_DrawHex_HeightLoop

	POP R8
	POP R7
	POP R6
	POP R4
	POP R3
	POP R1
	RET

;Input R0(ID)
;Output nothing
;Plays a video/sound
MD_Play:
	MOV [MD_Command_PlayVideoMusic],R0
	RET


;Input R0(ID)
;Output nothing
;Plays a video/sound on loop
MD_Loop:
	MOV [MD_Command_PlayVideoMusicLoop],R0
	RET


;Input R0(ID)
;Output nothing
;pauses a video/sound
MD_Pause:
	MOV [MD_Command_PauseVideoMusic],R0
	RET

;Input R0(ID)
;Output nothing
;unpauses a video/sound
MD_Unpause:
	MOV [MD_Command_ContinueVideoMusic],R0
	RET

;Input R0(ID)
;Output nothing
;Stops a video/sound
MD_Stop:
	MOV [MD_Command_StopsVideoMusic],R0
	RET
; BCD.asm - Binary Coded Decimal library

;returns value of R0 in R1 as BCD
BC_ToBCD:
	PUSH R0
					; Build BCD directly to R1
	PUSH R2			; Remainder divider
	PUSH R3			; Remainder store
	PUSH R4			; Iter counter
	
	XOR R1, R1		; Clear output
	MOV R2, 10000	; Initialize clamp divider
	MOD R0, R2		; Clamp input to allowed values
	
	MOV R2, 10		; Initialize divider
	MOV R4, 4		; Initialize counter
	
	
_BC_ToBCD_loop:
	SHR R1, 4		; Shift output to clear space
	MOV R3, R0		; Copy input
	MOD R3, R2		; Get %10
	SHL R3,	12		; Shift value to highest 4 bits
	ADD R1, R3		; Add to output
	DIV R0, R2		; Divide (shift) input
	SUB R4, 1		; Decrement counter
	JNZ _BC_ToBCD_loop
	
_BC_ToBCD_end:
	POP R4
	POP R3
	POP R2
	POP R0
	RET
	
	
;Write R0 to hexadecimal display
BC_WriteToDisp:
	PUSH R1
	MOV R1, _BC_HexOut	; Display pointer
	MOV [R1], R0		; Write value
	POP R1
	RET

; Draws score bar and writes to hex display
SB_DrawSB:
	PUSH R0
	
	;Check draw flag early to minimize performance drop
	MOV R0, [_SB_DrawFlag]
	CMP R0, 0
	JEQ _SB_DrawSB_flagAbort
	
	PUSH R1				; <draw call args>
	PUSH R2				; <draw call args>
	PUSH R3				; <draw call args>
	PUSH R4				; <draw call args>
	PUSH R5				; fillPixels / colorTmp
	PUSH R6				; maxX / conversion bkp
	PUSH R7				; maxY
	PUSH R10			; aux
	
	MOV R0, [_SB_Score]	; Get score
	
_SB_DrawSB_writePercent:
	MOV R10, 100
	MUL R0, R10			; R0 = (R0 * 100) / MAX (to get percent)
	MOV R10, _SB_MAX
	DIV R0, R10
	
	CALL BC_ToBCD		; Get percent BCD
	MOV R0, R1			; (mov to R0 for call)
	CALL BC_WriteToDisp	; Print BCD to hex
	
_SB_DrawSB_calcFill:
	MOV R0, [_SB_Score]	; Get score again
	MOV R5, R0			; fillPixels = score * HEIGHT * WIDTH / MAX
	MOV R10, _SB_BHEIGHT
	MUL R5, R10
	MOV R10, _SB_BWIDTH
	MUL R5, R10
	MOV R10, _SB_MAX
	DIV R5, R10
	
_SB_DrawSB_calcBounds:
	MOV R6, R5			; maxX = fillPixels % BWIDTH
	MOV R10, _SB_BWIDTH
	MOD R6, R10
	
	MOV R7, R5			; maxY = fillPixels / BWIDTH
	DIV R7, R10
	
_SB_DrawSB_clearBar:
	MOV R0, _SB_CORNER_X
	MOV R1, _SB_CORNER_Y
	MOV R2, _SB_BWIDTH
	MOV R3, _SB_BHEIGHT
	MOV R4, 0
	;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
	CALL MD_DrawRect
	
_SB_DrawSB_draw:	
	MOV R0, _SB_CORNER_X		; Set cornerX (const)
	MOV R1, _SB_CORNER_Y		; cornerY = CORNER_Y + BHEIGHT - maxY
	MOV R10, _SB_BHEIGHT
	ADD R1, R10
	SUB R1, R7
	MOV R2, _SB_BWIDTH			; Set width (const)
	MOV R3, R7				; Set height = maxY
	CMP R3, 0
	JEQ _SB_DrawSB_drawPartial	; if (height == 0) only draw partial
	;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
	MOV R4, [_SB_Color]	; Get color
	CALL MD_DrawRect
	
_SB_DrawSB_drawPartial: ;TODO: Fix draw partial not drawing on first line
	CMP R6, 0
	JEQ _SB_DrawSB_End
	MOV R0, _SB_CORNER_X
	MOV R1, _SB_CORNER_Y		; cornerY = CORNER_Y + BHEIGHT - maxY - 1
	MOV R10, _SB_BHEIGHT
	ADD R1, R10
	SUB R1, R7
	SUB R1, 1
	MOV R2, R6
	MOV R3, 1
	;Color already set
	;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
	CALL MD_DrawRect
	
_SB_DrawSB_End:
	POP R10
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	
	;Reset flag
	XOR R0, R0
	MOV [_SB_DrawFlag], R0
	
_SB_DrawSB_flagAbort:
	POP R0
	RET
	
; Steps the color animation
SB_UpdateColor:
	PUSH R0	; Color store
	PUSH R1	; Auxiliar
	
	MOV R0, [_SB_Color]	; Get current color
	MOV R1, 00FFFH		; 12 low bits bitmask
	AND R0, R1			; Get low 12 bits (color)
	SHL R0, 1			; Shift (rotate) color
	BIT R0, 12			; Get overflow bit
	JEQ _SB_UpdateColor_NoV
	ADD R0, 1
_SB_UpdateColor_NoV:
	MOV R1, 0F000H		; Alpha mask (max)
	OR R0, R1
	MOV [_SB_Color], R0
	
	POP R1
	POP R0
	RET

;Resets score to 0
SB_ResetScore:
	PUSH R0
	XOR R0, R0
	MOV [_SB_Score], R0
	POP R0
	RET
	
;Adds score based on the number of lines cleared in R0
SB_AddScore:
	CMP R0, 0
	JEQ _SB_AddScore_ret
	PUSH R0
	PUSH R1
	
	MOV R1, 1
	
_SB_AddScore_loop:
	SHL R1, 1
	SUB R0, 1
	JNE _SB_AddScore_loop
	
	MOV R0, [_SB_Score]
	ADD R0, R1
	MOV [_SB_Score], R0
	
	MOV R1, _SB_MAX
	CMP R0, R1
	JLT _SB_AddScore_noWin
	CALL MAN_ShowWinScreen
	
_SB_AddScore_noWin:
	POP R1
	POP R0
_SB_AddScore_ret:
	RET

;Sets draw flag
SB_EnableDrawFlag:
	PUSH R0
	MOV R0, 1
	MOV [_SB_DrawFlag], R0
	POP R0
	RET
	
;Resets draw flag
SB_DisableDrawFlag:
	PUSH R0
	XOR R0, R0
	MOV [_SB_DrawFlag], R0
	POP R0
	RET
; keyboard.asm - Keyboard interfacing functions

; includes
; Manager.asm


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

; Returns first pressed key in R0
KB_GetKey:
	PUSH R1 	; keyboard output pointer (write test)
	PUSH R2 	; keyboard input pointer (read key)
	PUSH R3 	; current bit for test
	PUSH R4 	; test bit shift counter
	PUSH R5		; bit mask & R0 shift counter

	MOV R1, _KB_KEYO
	MOV R2, _KB_KEYI
	MOV R3, 1
	XOR R4, R4
	MOV R5, 0FH
	
_KB_GetKey_loop:
	MOVB [R1], R3		; put test bit
	MOVB R0, [R2]		; read mask
	AND R0, R5			; mask first 4 bits
	CMP R0, 0			; MOVB doesn't affect flags
	JNE _KB_GetKey_dec	; found a key press
	SHL R3, 1			; shift test bit
	ADD R4, 1			; increment shift counter
	CMP R4, 4			; check loop end (4 bit shifts)
	JNE _KB_GetKey_loop ; repeat loop
	MOV R0, 0FFFFH		; -1 for empty
	JMP _KB_GetKey_end
	
_KB_GetKey_dec: 		; decode
	XOR R5, R5			; R5 = 0
	
_KB_GetKey_dlp:			; get bit position
	ADD R5, 1			; R5++
	SHR R0, 1			; R0 >>= 1
	JNE _KB_GetKey_dlp	; while (R0) goto _KB_GetKey_dlp

_KB_GetKey_df:
	SUB R5, 1			; R5-- (it's in [1,4])
	SHL R4, 2			; R0 = (R4 << 2) | R5
	OR R5, R4
	MOV R0, R5
	
_KB_GetKey_end:
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET


; Returns non-zero in R1 if the key specified in R0 is pressed
KB_IsKeyPressed:
	MOV R1, R0
	CALL KB_GetKey
	CMP R0, R1
	MOV R1, R0
	JEQ _KB_IsKeyPressed_end
	XOR R1, R1
	
_KB_IsKeyPressed_end:
	RET


; Polls keyboard and sets up the key
KB_PollKey:
	PUSH R0
	PUSH R1						; Press_Handles base pointer
	PUSH R2						; Hold_Handles base pointer
	PUSH R3						; Auxiliar
	
	MOV R1, _KB_Press_Handles	; Load pointers
	MOV R2, _KB_Hold_Handles
	
_KB_PollKey_start:
	CALL KB_GetKey
	
	CMP R0, 0FFFFH					; Check for empty key
	JEQ _KB_PollKey_end				; Skip if empty
	
	SHL R0, 1						; Multiply by 2 (word size)
	
_KB_PollKey_hold:
	MOV R3, [_KB_NextKeyHoldHandle] ; Check for handle already set
	TEST R3, R3						; (Update Z flag)
	JNE _KB_PollKey_press			; Ignore if handle is set
	
	MOV R3, [R2 + R0]				; Get handle
	MOV [_KB_NextKeyHoldHandle], R3	; Set next handle

_KB_PollKey_press:
	MOV R3, [_KB_NextKeyPressHandle]; Check for handle already set
	TEST R3, R3						; (Update Z flag)
	JNE _KB_PollKey_end				; Ignore if handle is set
	
	MOV R3, [_KB_LastKeyPressed]	; Check if key pressed changed
	CMP R0, R3
	JEQ _KB_PollKey_end				; Skip if press didn't change
	
	MOV R3, [R1 + R0]				; Get handle
	MOV [_KB_NextKeyPressHandle], R3; Set next handle
	
_KB_PollKey_end:
	MOV [_KB_LastKeyPressed], R0	; Update last key pressed

	POP R3
	POP R2
	POP R1
	POP R0
	RET

KB_EnableHandle:
	PUSH R0
	MOV R0, 1
	MOV [_KB_HandleFlag], R0
	POP R0
	RET

; Polls keyboard and executes assigned functions
KB_DoHandles:
	PUSH R0	; Handle pointer
	
	MOV R0, [_KB_HandleFlag]
	TEST R0, R0
	JEQ _KB_DoHandles_end
	XOR R0, R0
	MOV [_KB_HandleFlag], R0		; Reset handle flag
	
_KB_DoHandles_hold:
	MOV R0, [_KB_NextKeyHoldHandle]	; Load handle pointer
	TEST R0, R0						; (Update Z flag)
	JEQ _KB_DoHandles_press			; Skip if NULL
	CALL R0							; Call handle

_KB_DoHandles_press:
	MOV R0, [_KB_NextKeyPressHandle]; Load handle pointer
	TEST R0, R0						; (Update Z flag)
	JEQ _KB_DoHandles_reset			; Skip if NULL
	CALL R0							; Call handle
	
_KB_DoHandles_reset:
	XOR R0, R0						; Reset handle pointers
	MOV [_KB_NextKeyHoldHandle], R0
	MOV [_KB_NextKeyPressHandle], R0

_KB_DoHandles_end:
	POP R0
	RET

; Sets all interrupt flags as needed and configures the BTE
IT_SetupInterrupts:
	PUSH R0
	PUSH R1
	
	MOV BTE, _IT_interrupt_vectors	; load interrupt vector table
	MOV R0, RE
	MOV R1, _IT_CLR_TV_TD			; Clear TV & TD
	AND R0, R1
	MOV R1, _IT_SET_INTS			; Set IE and IE# (0-3)
	OR R0, R1
	MOV RE, R0
	
	POP R1
	POP R0
	RET


; Pauses interrupts related to gameplay
IT_DisableGameInterrupts:
	PUSH R0
	MOV R0, _IT_CLR_GINTS			; Load bitmask
	AND RE, R0						; Clear interrupt bits
	POP R0
	RET


; Resumes interrupts related to gameplay
IT_EnableGameInterrupts:
	PUSH R0
	MOV R0, _IT_SET_GINTS			; Load bitmask
	OR RE, R0						; Set interrupts bits
	POP R0
	RET

; ===Interrupt handlers===

_IT_INT0:
_IT_drawINT:
	CALL SB_EnableDrawFlag
	CALL TL_EnableDrawFlag
	RFE
	
_IT_INT1:
_IT_animationINT:
	CALL SB_UpdateColor ; Should be inlined
	RFE
	
_IT_INT2:
_IT_gravityINT:
	CALL TL_EnableGravityFlag
	RFE
	
_IT_INT3:
_IT_inputINT:
	CALL KB_EnableHandle ; Should be inlined
	RFE
	
_IT_EXCESSO:
_IT_DIV0:
_IT_Discard:
	RFE
	
_IT_COD_INV:
	RFE
	
_IT_D_DESALINHADO:
	RFE
	
_IT_I_DESALINHADO:
	RFE
;TetraLogic.asm
;Holding itself together with Hopes And Dreams~~~

; RNG.asm

;Input Nothing
;Output R0 random value
;Steps The RNG value
RNG_STEP:

	PUSH R1;RNG_ADDRESS
	PUSH R2;Tmp Value Holder

	MOV R1,RNG_ADDRESS
	MOV R0,[R1];Aquire RNG Value From Memory

	MOV R2,R0 ;R2 = R0
	SHR R2,7  ;R2 >> 7
	XOR R0,R2 ;R0 ^= R2

	MOV R2,R0 ;R2 = R0
	SHL R2,3  ;R2 << 3
	XOR R0,R2 ;R0 ^= R2

	MOV R2,R0 ;R2 = R0
	SHR R2,8  ;R2 >> 8
	XOR R0,R2 ;R0 ^= R2

	MOV [R1],R0 ;Put New Rng Value Back into Memory

	POP R2;Restore
	POP R1

	RET

;Input nothing
;Output nothing
;Clears The Board
TL_ResetBoard:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0,_TL_Board
	MOV R1,_TL_BoardArea * 2 	;Table size in bytes
	MOV R2,0					;Empty state

_TL_ResetBoard_loop:
	SUB R1,2
	MOV [R0+R1],R2
	CMP R1,0
	JNZ _TL_ResetBoard_loop

	POP R2
	POP R1
	POP R0

	RET

;Input R0(ID)
;Output nothing
;Makes a Tetra in memmory with the id
TL_MakeTetra:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	MOV R1,_TL_Tetras
	MOV R2,_TL_MovingTetra

	MOV [R2],R0;SET ID

	SHL R0,1
	ADD R1,R0;get offset of pointer

	MOV R1,[R1];get actual Tetra data

	MOV R3,[R1]
	MOV [R2+2],R3;Set Next Tetra
	ADD R2,2
	MOV R4,8

_TL_MakeTetra_loop:
	ADD R2,2;Copy Data
	ADD R1,2
	MOV R3,[R1]
	MOV [R2],R3
	SUB R4,1
	CMP R4,0
	JNZ _TL_MakeTetra_loop

	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;Inputs nothing
;Output nothing
;"Rotates" the tetra to the next shape if it can
TL_RotateTetra:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6

	MOV R0,_TL_MovingTetra
	ADD R0,2
	MOV R1,[R0];Get Value of pointer
	MOV R2,[R1];Get Value of pointer

	ADD R0,2;Copy Data
	ADD R1,2

	MOV R5,[R0+0];Get Block0X
	MOV R6,[R0+2];Get Block0Y
	MOV R3,[R1+0]
	MOV R4,[R1+2]
	SUB R5,R3
	SUB R6,R4

	MOV R4,4

_TL_RotateTetra_testloop:
	PUSH R4
	PUSH R0   ;Verify This
	PUSH R2

	MOV R3,[R1];get new X
	ADD R3,R5
	ADD R1,2

	MOV R4,[R1];get new Y
	ADD R4,R6
	ADD R1,2

	PUSH R1


	MOV R0,R3
	MOV R1,R4
	CALL TL_TryBlock

	POP R1
	POP R2
	POP R0

	POP R4

	JNZ _TL_RotateTetra_Cancel

	SUB R4,1
	CMP R4,0
	JNZ _TL_RotateTetra_testloop

	MOV R0,_TL_MovingTetra
	ADD R0,2
	MOV R1,[R0];Get Value of pointer
	MOV R2,[R1];Get Value of pointer
	MOV [R0],R2;Set Next Tetra pointer

	ADD R0,2;Copy Data
	ADD R1,2


	MOV R4,4

_TL_RotateTetra_loop:

	MOV R3,[R1];get new X
	ADD R3,R5
	MOV [R0],R3
	ADD R0,2;Copy Data
	ADD R1,2

	MOV R3,[R1];get new Y
	ADD R3,R6
	MOV [R0],R3
	ADD R0,2;Copy Data
	ADD R1,2

	SUB R4,1
	CMP R4,0
	JNZ _TL_RotateTetra_loop

_TL_RotateTetra_Cancel:
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;Input nothing
;Output nothing
;Slams Down The Tetra
TL_SlamTetra:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0,0
	MOV R1,1
TL_SlamTetra_loop:
	CALL TL_MoveTetra
	CMP R2,1
	JNN TL_SlamTetra_loop
	
	POP R2
	POP R1
	POP R0
	RET

;Input R0(X) R1(Y)
;Output R2(Succsess or not)
;Moves the tetra by X and Y if it can
TL_MoveTetra:
	PUSH R3
	PUSH R4
	PUSH R5

;TEST LOOP
	MOV R2,_TL_MovingTetra
	MOV R3,4
_TL_MoveTetra_testloop:
	ADD R2,4;go to blocks

	PUSH R0 ;[TODO : maybe break this routine down]
	PUSH R1

	PUSH R3
	PUSH R4

	MOV R3,[R2+0]
	MOV R4,[R2+2]
	ADD R0,R3;OFFSETS
	ADD R1,R4

	POP R4
	POP R3

	PUSH R2

	CALL TL_TryBlock

	POP R2
	POP R1
	POP R0

	JNZ _TL_MoveTetra_Cancel

	SUB R3,1
	CMP R3,0
	JNZ _TL_MoveTetra_testloop

	MOV R2,_TL_MovingTetra
	MOV R3,4

;ACTUAL MOVE LOOP
	MOV R2,_TL_MovingTetra
	MOV R3,4
_TL_MoveTetra_loop:
	ADD R2,4;go to blocks
	MOV R4,[R2+0]
	MOV R5,[R2+2]
	ADD R4,R0
	ADD R5,R1
	MOV [R2+0],R4
	MOV [R2+2],R5
	SUB R3,1
	CMP R3,0
	JNZ _TL_MoveTetra_loop

	POP R5
	POP R4
	POP R3

	MOV R2,1
	RET

_TL_MoveTetra_Cancel:
	POP R5
	POP R4
	POP R3

	MOV R2,0

	RET

;Input R0(X) R1(Y)
;Output R2(Can/Can't)
;
TL_TryBlock:
	
	CMP R0,0
	JNN _TL_PassXMin
	MOV R2,1
	RET
_TL_PassXMin:
	MOV R2,9
	CMP R0,R2
	JN _TL_PassXMax
	JZ _TL_PassXMax
	MOV R2,1
	RET
_TL_PassXMax:
	CMP R1,0
	JNN _TL_PassYMin
	MOV R2,1
	RET
_TL_PassYMin:
	MOV R2,19
	CMP R1,R2
	JN _TL_PassYMax
	JZ _TL_PassYMax
	MOV R2,1
	RET
_TL_PassYMax:

	PUSH R0
	PUSH R1
	PUSH R3

	MOV R2,_TL_Board
	MOV R3,10
	MUL R1,R3
	SHL R0,1
	SHL R1,1
	ADD R2,R0
	ADD R2,R1
	MOV R2,[R2]

	POP R3
	POP R1
	POP R0

	CMP R2,0
	JNZ _TL_TryBlock_No
	MOV R2,1
	RET
_TL_TryBlock_No:
	MOV R2,0
	RET

;Input nothing
;Output nothing
;Draws the tetra 
TL_DrawMovingTetra:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	MOV R4,_TL_TetraColors;get colors
	MOV R5,_TL_MovingTetra;get data
	MOV R6,[R5];aquire id
	SHL R6,1;mult 2
	ADD R4,R6
	MOV R4,[R4];get color for this id
	
	MOV R2,2
	MOV R3,2;set up the draw call
	MOV R6,4

_TL_DrawMovingTetra_loop:
	ADD R5,4;go to blocks
	MOV R0,[R5+0]
	SHL R0,1
	ADD R0,1;Board Offset
	MOV R1,[R5+2]
	SHL R1,1
	ADD R1,6;Board Offset
	ADD R1,6;Btw Very Anoying -8 to 7 range
	ADD R1,2;Board Offset
	CALL MD_DrawRect
	SUB R6,1
	CMP R6,0
	JNZ _TL_DrawMovingTetra_loop
	
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;Input nothing
;Output nothing
;
TL_FinalizeTetra:

	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7

	MOV R0,_TL_MovingTetra
	MOV R1,_TL_Board
	MOV R2,[R0];ID
	MOV R6,4
	MOV R7,10

_TL_FinalizeTetra_loop:
	ADD R0,4
	MOV R4,[R0+0];X
	MOV R5,[R0+2];Y
	MUL R5,R7
	ADD R4,R5
	SHL R4,1
	MOV [R1+R4],R2
	SUB R6,1
	CMP R6,0
	JNZ _TL_FinalizeTetra_loop

	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;Input Nothing
;Output R0(lines cleard)
;Finds Clears Moves and returns the cleard lines
TL_BoardCheck:
	PUSH R1
	PUSH R2
	PUSH R3

	MOV R0,19
	MOV R2,20
	MOV R3,0

_TL_BoardCheck_loop:
	CALL TL_LineCheck

	CMP R1,0

	JZ _TL_BoardCheck_skip
	CALL TL_LineFall
	ADD R3,1
	ADD R0,1
_TL_BoardCheck_skip:
	SUB R0,1
	SUB R2,1
	CMP R2,0
	JNZ _TL_BoardCheck_loop

	MOV R0,R3

	POP R3
	POP R2
	POP R1
	RET

;Input R0(index)
;Output R1(did something)
;Finds Clears Moves and returns the cleard line
TL_LineCheck:
	PUSH R0
	PUSH R2

	MOV R1,10
	MUL R0,R1
	SHL R0,1
	MOV R2,_TL_Board
	ADD R0,R2

	MOV R2,10

_TL_LineCheck_loop:
	MOV R1,[R0]
	ADD R0,2
	CMP R1,0
	JZ _TL_LineCheck_fail

	SUB R2,1
	CMP R2,0
	JNZ _TL_LineCheck_loop

	POP R2
	POP R0

	MOV R1,1

	RET

_TL_LineCheck_fail:

	POP R2
	POP R0

	MOV R1,0
	RET

;Input R0(index)
;Output nothing
;Makes Lines Above "fall down"
TL_LineFall:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

	ADD R0,1
	MOV R1,10
	MUL R0,R1
	SHL R0,1
	MOV R2,_TL_Board
	ADD R0,R2
	MOV R1,22
	ADD R2,R1
	MOV R1,-20

_TL_LineFall_loop:
	SUB R0,2
	MOV R3,[R0+R1]
	MOV [R0],R3
	CMP R0,R2
	JNN _TL_LineFall_loop

	MOV R2,_TL_Board
	ADD R2,2

_TL_LineFall_loop_finalize:
	SUB R0,2
	MOV R3,0
	MOV [R0],R3
	CMP R0,R2
	JNN _TL_LineFall_loop_finalize

	POP R3
	POP R2
	POP R1
	POP R0
	RET

; Draw the playing board
TL_DrawBoard:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8

	MOV R0,_TL_Board
	MOV R1,_TL_TetraColors
	MOV R3,20
	MOV R4,14
	MOV R6,1
	MOV R7,0
	MOV R8,0

_TL_DrawBoard_height:
	MOV R2,10

	MOV [MD_Command_SetX],R6;Set X
	MOV [MD_Command_SetY],R4;Set Y
	MOV R8,R0
_TL_DrawBoard_width:
	MOV R5,[R0]
	SHL R5,1
	MOV R5,[R1+R5]
	MOV [MD_Command_Draw],R5;Draw
	MOV [MD_Command_Draw],R5;Draw
	ADD R0,2

;end width

	SUB R2,1
	CMP R2,0
	JNZ _TL_DrawBoard_width

;end height

	CMP R7,0
	JZ _TL_DrawBoard_skip
	SUB R3,1
	MOV R7,-1
	JMP _TL_DrawBoard_noskip
_TL_DrawBoard_skip:
	MOV R0,R8
_TL_DrawBoard_noskip:
	ADD R4,1
	ADD R7,1
	CMP R3,0
	JNZ _TL_DrawBoard_height

	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;Input nothing
;Output nothing
;Draw All TetraLogic stuff
TL_DrawTetraLogic:
	PUSH R0
	; Check flag early to lower performance impact
	MOV R0, [_TL_DrawFlag]
	CMP R0, 0
	JEQ TL_DrawTetraLogic_flagAbort ; Skip if flag not set
	
	CALL TL_DrawBoard
	CALL TL_DrawMovingTetra
	CALL TL_DrawNextTertra
	
	XOR R0, R0
	MOV [_TL_DrawFlag], R0 ; Reset flag
	
TL_DrawTetraLogic_flagAbort:
	POP R0
	RET

;Input nothing
;Output nothing
;Moves The Tetra Left (wow)
TL_MoveTetraLeft:
	PUSH R0
	PUSH R1

	MOV R0,-1
	MOV R1,0
	CALL TL_MoveTetra

	POP R1
	POP R0
	RET

;Input nothing
;Output nothing
;Moves The Tetra Right (wow)
TL_MoveTetraRight:
	PUSH R0
	PUSH R1

	MOV R0,1
	MOV R1,0
	CALL TL_MoveTetra

	POP R1
	POP R0
	RET

;Input nothing
;Output nothing
;Inializes the tetralogic stuff
TL_InitTetraLogic:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R2,7
	CALL TL_ResetBoard
	CALL RNG_STEP
	MOD R0,R2
	ADD R0,1
	MOV R1,_TL_NextTetra
	MOV [R1],R0
	CALL RNG_STEP
	MOD R0,R2
	ADD R0,1
	CALL TL_MakeTetra
	MOV R0,4
	MOV R1,0
	CALL TL_MoveTetra

	POP R2
	POP R1
	POP R0
	RET

;Input nothing
;Output nothing
;Makes the new moving tetra from the next and makes a new next
TL_MakeNextTetra:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

	CALL TL_FinalizeTetra
	MOV R3,7
	MOV R2,_TL_NextTetra
	MOV R0,[R2]
	CALL TL_MakeTetra
	MOV R0,4
	MOV R1,0
	CALL TL_MoveTetra
	CALL RNG_STEP
	MOD R0,R3
	ADD R0,1
	MOV R2,_TL_NextTetra
	MOV [R2],R0

	POP R3
	POP R2
	POP R1
	POP R0
	RET

;Input nothing
;Output nothing
;Makes The Piece Gravatity and ending
TL_TetraLogicGrav:
	PUSH R0
	;Check flag early to minimize performance impact
	MOV R0, [_TL_GravFlag]
	CMP R0, 0
	JEQ _TL_TetraLogicGrav_flagAbort
	
	PUSH R1
	PUSH R2

	MOV R0,0
	MOV R1,1
	CALL TL_MoveTetra
	CMP R2,1
	JZ _TL_TetraLogicGrav_Nocoll

	CALL TL_MakeNextTetra
	CALL TL_BoardCheck
	CALL SB_AddScore
	CALL MAN_LineCleared
	;[TODO : Score Goes Here]

_TL_TetraLogicGrav_Nocoll:
	POP R2
	POP R1
	
	;Reset flag
	XOR R0, R0
	MOV [_TL_GravFlag], R0
	
_TL_TetraLogicGrav_flagAbort:
	POP R0
	RET

;Input nothing
;Output nothing
;Clears the next tetra holder spot
TL_ClearNextTetra:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	MOV R0,23
	MOV R1,38
	MOV R2,8
	MOV R3,8
	MOV R4,0000H

	CALL MD_DrawRect

	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET


TL_DrawNextTertra:

	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7

	CALL TL_ClearNextTetra

	MOV R0,_TL_NextTetra
	MOV R0,[R0];ID

	SHL R0,1

	MOV R1,_TL_TetraColors
	MOV R1,[R1+R0];Color

	MOV R2,_TL_Tetras
	MOV R2,[R2+R0]
	MOV R2,[R2]
	ADD R2,2;BlockData

	SHR R0,1
	MOV R7,4

_TL_DrawNextTertra_loop:

	MOV R3,23
	MOV R4,38
	MOV R5,[R2]
	SHL R5,1
	MOV R6,[R2+2]
	SHL R6,1
	ADD R3,R5
	ADD R4,R6
	MOV [MD_Commands+0CH],R3;Set X
	MOV [MD_Commands+0AH],R4;Set Y
	MOV [MD_Commands+12H],R1;Draw
	MOV [MD_Commands+12H],R1;Draw
	MOV [MD_Commands+0CH],R3;Set X
	ADD R4,1
	MOV [MD_Commands+0AH],R4;Set Y
	MOV [MD_Commands+12H],R1;Draw
	MOV [MD_Commands+12H],R1;Draw

	ADD R2,4
	SUB R7,1
	CMP R7,0
	JNZ _TL_DrawNextTertra_loop

	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

; Sets draw flag
TL_EnableDrawFlag:
	PUSH R0
	MOV R0, 1
	MOV [_TL_DrawFlag], R0
	POP R0
	RET
	
; Sets gravity flag
TL_EnableGravityFlag:
	PUSH R0
	MOV R0, 1
	MOV [_TL_GravFlag], R0
	POP R0
	RET
	
; Resets draw flag
TL_DisableDrawFlag:
	PUSH R0
	XOR R0, R0
	MOV [_TL_DrawFlag], R0
	POP R0
	RET
	
; Resets gravity flag
TL_DisableGravityFlag:
	PUSH R0
	XOR R0, R0
	MOV [_TL_GravFlag], R0
	POP R0
	RET
