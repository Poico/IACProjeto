; ScoreBar.asm - Functions to draw an animated score bar

WIDTH		EQU 32
HEIGHT		EQU 64
BWIDTH 		EQU 4
BHEIGHT		EQU 12
CORNER_X	EQU 25
CORNER_Y	EQU 18
MAX			EQU 100

#include:MediaDrive.asm
#include:BCD.asm

; Draws score bar and writes to hex display
SB_DrawSB:
	PUSH R0
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
	MOV R10, MAX
	DIV R0, R10
	
	CALL BC_ToBCD		; Get percent BCD
	MOV R0, R1			; (mov to R0 for call)
	CALL BC_WriteToDisp	; Print BCD to hex
	
_SB_DrawSB_calcFill:
	MOV R0, [_SB_Score]	; Get score again
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
	MOV R4, [_SB_Color]	; Get color
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
	JEQ R0, _SB_AddScore_ret
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
	
	POP R1
	POP R0
_SB_AddScore_ret:
	RET
	
	
_SB_Color:
	WORD 0FF00H
	
_SB_Score:
	WORD 0
