;test_main.asm - Random testing

;draws a filling progress bar (5x10) at (3,3)

VIDEO 		EQU 8000H
WIDTH		EQU 32
HEIGHT		EQU 64
BWIDTH 		EQU 5
BHEIGHT		EQU 20
CORNER_X	EQU 3
CORNER_Y	EQU 3
MAX			EQU 100

PLACE 0
entry:
	MOV SP, stack_top

	CALL Inicialize

	MOV R4, 0FF00H		; color
	XOR R5, R5			; score
	MOV R6, R5			; fillPixels
	MOV R7, R5			; maxX
	MOV R8, R5			; maxY
	MOV R9, R5			; helper
	
loop:
	CALL sleep
	MOV R6, R5			; fillPixels = score * HEIGHT * WIDTH / MAX
	MOV R9, BHEIGHT
	MUL R6, R9
	MOV R9, BWIDTH
	MUL R6, R9
	MOV R9, MAX
	DIV R6, R9
	
	MOV R7, R6			; maxX = fillPixels % BWIDTH
	MOV R9, BWIDTH
	MOD R7, R9
	
	MOV R8, R6			; maxY = fillPixels / BWIDTH
	DIV R8, R9
	
	; drawing
	; draw full part first
	MOV [MEDIA_CENTER + 02H],R0;clear screen(s)
	MOV R0, CORNER_X
	MOV R1, CORNER_Y
	MOV R2, BWIDTH
	MOV R3, R8			
	CMP R3, 0
	JEQ draw_partial	; if (height == 0) only draw partial
	SUB R3, 1			; height = maxY - 1
	JEQ draw_partial
;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
	CALL DRAW_RECT
	
	
draw_partial:
	; TODO: Implement

loop_end:
	ADD R5, 1			; score++
	MOV R10, MAX
	CMP R5, R10			;
	JNE loop
	MOV R5, 0
	JMP loop
	
	
sleep:
	PUSH R0
	MOV R0, 0FFFFH
	
sleep_loop:
	SUB R0, 1
	JNE sleep_loop
	
	POP R0
	RET

end:
	JMP end

#include:../lib/MediaDrive.asm

PLACE 3800H
STACK 07FEH
PLACE 3FFEH
stack_top:
