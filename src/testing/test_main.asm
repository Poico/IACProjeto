;test_main.asm - Random testing

;draws a filling progress bar (5x10) at (3,3)

PLACE 0
entry:
	MOV SP, stack_top

	CALL MD_InitMedia
	
	MOV R0, 0
	MOV [6042H], R0

	XOR R0, R0			; score
	
loop:
	CALL sleep
	CALL MD_ClearScrean
	CALL SB_DrawSB
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

PLACE 3800H
STACK 07FEH
PLACE 3FFEH
stack_top:
