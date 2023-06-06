;TetraLogic.asm
;Holding itself together with Hopes And Dreams~~~

#include:MediaDrive.asm
#include:RNG.asm

_TL_TetraColors: WORD 0000H,0FFF0H	,0FF00H	,0F5F8H	   ,0F0FFH	,0F00FH	,0FF80H	   ,0F70FH
_TL_Tetras: WORD	  0000H,_TL_Square,_TL_Z_Horz,_TL_invZ_Horz,_TL_I_Vert,_TL_L_ANG0,_TL_invL_ANG0,_TL_T_ANG0
				;Master Block
				;NEXT SHAPE BL1X BL1Y BL2X BL2Y BL3X BL3Y BL4X BL4Y
_TL_Square: WORD _TL_Square,0000,0000,0001,0000,0001,0001,0000,0001

_TL_Z_Horz: WORD _TL_Z_Vert,0001,0001,0000,0000,0001,0000,0002,0001
_TL_Z_Vert: WORD _TL_Z_Horz,0000,0001,0001,0000,0001,0001,0000,0002

_TL_invZ_Horz: WORD _TL_invZ_Vert,0001,0001,0000,0001,0001,0000,0002,0000
_TL_invZ_Vert: WORD _TL_invZ_Horz,0000,0001,0000,0000,0001,0001,0001,0002

_TL_I_Horz: WORD _TL_I_Vert,0001,0000,0000,0000,0002,0000,0003,0000
_TL_I_Vert: WORD _TL_I_Horz,0000,0001,0000,0000,0000,0002,0000,0003

_TL_L_ANG0 : WORD _TL_L_ANG1,0000,0001,0000,0000,0000,0002,0001,0002
_TL_L_ANG1 : WORD _TL_L_ANG2,0001,0001,0000,0001,0002,0001,0002,0000
_TL_L_ANG2 : WORD _TL_L_ANG3,0001,0001,0000,0000,0001,0000,0001,0002
_TL_L_ANG3 : WORD _TL_L_ANG0,0001,0000,0000,0000,0000,0001,0002,0000

_TL_invL_ANG0 : WORD _TL_invL_ANG1,0001,0001,0001,0000,0001,0002,0000,0002
_TL_invL_ANG1 : WORD _TL_invL_ANG2,0001,0000,0000,0000,0002,0000,0002,0001
_TL_invL_ANG2 : WORD _TL_invL_ANG3,0000,0001,0001,0000,0000,0000,0000,0002
_TL_invL_ANG3 : WORD _TL_invL_ANG0,0001,0001,0000,0001,0000,0000,0002,0001

_TL_T_ANG0 : WORD _TL_T_ANG1,0001,0001,0001,0000,0002,0001,0001,0002
_TL_T_ANG1 : WORD _TL_T_ANG2,0001,0001,0002,0001,0001,0002,0000,0001
_TL_T_ANG2 : WORD _TL_T_ANG3,0001,0001,0001,0002,0000,0001,0001,0000
_TL_T_ANG3 : WORD _TL_T_ANG0,0001,0001,0000,0001,0001,0000,0002,0001

_TL_MovingTetra:
	WORD 
	;ID   next
	 0000,0000
	,0000,0000 ;block 1
	,0000,0000 ;block 2
	,0000,0000 ;block 3
	,0000,0000 ;block 4

_TL_NextTetra:
	WORD 0000

_TL_Board:
	TABLE 200

;Input nothing
;OutPut nothing
;Clears The Board
TL_ResetBoard:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0,_TL_Board
	MOV R1,400
	MOV R2,0

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
;OutPut nothing
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

	MOV R3,[R1];get new X
	ADD R3,R5
	ADD R1,2

	MOV R4,[R1];get new Y
	ADD R4,R6
	ADD R1,2

	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0,R3
	MOV R1,R4
	CALL TL_TryBlock

	POP R2
	POP R1
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
;OutPut nothing
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
;OutPut R2(Succsess or not)
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
;OutPut R2(Can/Can't)
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
;OutPut nothing
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


	MOV [MD_Commands+0CH],R6;Set X
	MOV [MD_Commands+0AH],R4;Set Y
	MOV R8,R0
_TL_DrawBoard_width:
	MOV R5,[R0]
	SHL R5,1
	MOV R5,[R1+R5]
	MOV [MD_Commands+12H],R5;Draw
	MOV [MD_Commands+12H],R5;Draw
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
	CALL TL_DrawBoard
	CALL TL_DrawMovingTetra
	CALL TL_DrawNextTertra
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
;OutPut nothing
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
;OutPut nothing
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
