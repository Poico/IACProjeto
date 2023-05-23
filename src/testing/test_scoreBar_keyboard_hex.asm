;test_main.asm - Random testing

PLACE 0
entry:
	MOV SP, stack_top

	CALL MD_InitMedia
	
	MOV R0, 0
	MOV [6042H], R0

	XOR R0, R0			; score
	
loop:
	CALL sleep
	CALL SB_DrawSB

	PUSH R0
	MOV R0, 1
	MOV R1, 14
	MOV R2, 0FFF0H
	CALL MD_DrawPixel
	POP R0
	
	PUSH R0
	PUSH R1
	MOV R0, 0AH
	CALL KB_IsKeyPressed
	CMP R1, 0
	POP R1
	POP R0
	JEQ loop
	
	ADD R0, 1			; score++
	MOV R10, MAX
	CMP R0, R10			; loop till max
	JNE loop
	MOV R0, 0
	JMP loop
	
	
sleep:
	PUSH R0
	MOV R0, 01FFFH
	
sleep_loop:
	SUB R0, 1
	JNE sleep_loop
	
	POP R0
	RET

end:
	JMP end

#include:../lib/MediaDrive.asm
#include:../lib/ScoreBar.asm
#include:../lib/keyboard.asm

PLACE 3800H
STACK 07FEH
PLACE 3FFEH
stack_top:
