; ScoreBar.asm - Functions to draw an animated score bar

WIDTH		EQU 32
HEIGHT		EQU 64
BWIDTH 		EQU 4
BHEIGHT		EQU 12
CORNER_X	EQU 25
CORNER_Y	EQU 18
MAX			EQU 100

#include:MediaDrive.asm

; score in R0
SB_DrawSB:
	PUSH R0				; make a backup
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5				; fillPixels / colorTmp
	PUSH R6				; maxX
	PUSH R7				; maxY
	PUSH R10			; aux
	
_SB_DrawSB_calcFill:
	MOV R5, R0			; fillPixels = score * HEIGHT * WIDTH / MAX
	MOV R10, BHEIGHT
	MUL R5, R10
	MOV R10, BWIDTH
	MUL R5, R10
	MOV R10, MAX
	DIV R5, R10
	
_SB_DrawSB_calcBounds:
	MOV R6, R5			; maxX = fillPixels % BWIDTH
	MOV R10, BWIDTH
	MOD R6, R10
	
	MOV R7, R5			; maxY = fillPixels / BWIDTH
	DIV R7, R10
	
_SB_DrawSB_clearBar:
	MOV R0, CORNER_X
	MOV R1, CORNER_Y
	MOV R2, BWIDTH
	MOV R3, BHEIGHT
	MOV R4, 0
	;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
	CALL MD_DrawRect
	
_SB_DrawSB_updateColor:
	MOV R4, [_SB_Color]
	MOV R5, R4
	MOV R10, 1
	SHR R5, 11
	AND R5, R10
	SHL R4, 1
	MOV R10, 0F000H
	OR R4, R10
	OR R4, R5
	MOV [_SB_Color], R4
	
_SB_DrawSB_draw:	
	MOV R0, CORNER_X		; Set cornerX (const)
	MOV R1, CORNER_Y		; cornerY = CORNER_Y + BHEIGHT - maxY
	MOV R10, BHEIGHT
	ADD R1, R10
	SUB R1, R7
	MOV R2, BWIDTH			; Set width (const)
	MOV R3, R7				; Set height = maxY
	CMP R3, 0
	JEQ _SB_DrawSB_drawPartial	; if (height == 0) only draw partial
	;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
	CALL MD_DrawRect
	
_SB_DrawSB_drawPartial:
	CMP R6, 0
	JEQ _SB_DrawSB_End
	MOV R0, CORNER_X
	MOV R1, CORNER_Y		; cornerY = CORNER_Y + BHEIGHT - maxY - 1
	MOV R10, BHEIGHT
	ADD R1, R10
	SUB R1, R7
	SUB R1, 1
	MOV R2, R6
	MOV R3, 1
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
	POP R0
	RET
	
	
_SB_Color:
	WORD 0FF00H
