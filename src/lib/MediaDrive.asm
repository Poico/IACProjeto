; MediaDrive.asm

#section:equ
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

#section:data

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

#section:text

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
