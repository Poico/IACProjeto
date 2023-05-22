init:
    MOV SP,stack_start
    CALL MD_InitMedia
    CALL MD_SetBack

    MOV R0,1
    CALL TL_MakeTetra
    MOV R0,0
    MOV R1,0
    CALL TL_MoveTetra
    CALL TL_RotateTetra
    CALL TL_FinalizeTetra
    MOV R0,2
    MOV R1,0
    CALL TL_TryBlock
    CALL TL_DrawBoard
    CALL TL_DrawMovingTetra

end:
    JMP end

STACK 100H
stack_start:

_TL_TetraColors: WORD 0000H,0FF00H,0F0F0H,0F00FH

_TL_Tetras: WORD 0000H,_TL_Square,_TL_Z_Horz,_TL_I_Vert
                ;NEXT SHAPE BL1X BL1Y BL2X BL2Y BL3X BL3Y BL4X BL4Y
_TL_Square: WORD _TL_Square,0000,0000,0001,0000,0001,0001,0000,0001
_TL_Z_Horz: WORD _TL_Z_Vert,0001,0001,0000,0000,0001,0000,0002,0001
_TL_Z_Vert: WORD _TL_Z_Horz,0000,0001,0001,0000,0001,0001,0000,0002
_TL_I_Horz: WORD _TL_I_Vert,0001,0000,0000,0000,0002,0000,0003,0000
_TL_I_Vert: WORD _TL_I_Horz,0000,0001,0000,0000,0000,0002,0000,0003

_TL_MovingTetra:
    WORD 
    ;ID   next
     0000,0000
    ,0000,0000 ;block 1
    ,0000,0000 ;block 2
    ,0000,0000 ;block 3
    ,0000,0000 ;block 4

_TL_Board:
    TABLE 200

;Input R0(ID)
;OutPut nothing
;Makes a Tetra in memmory whit the id
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
;"Rotates" the tetra to the next shape
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
    MOV [R0],R2;Set Next Tetra pointer

    ADD R0,2;Copy Data
    ADD R1,2

    MOV R5,[R0+0];Get Block0X
    MOV R6,[R0+2];Get Block0Y
    MOV R3,[R1+0]
    MOV R4,[R1+2]
    SUB R5,R3
    SUB R6,R3

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

    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0

    RET

;Input R0(X) R1(Y)
;OutPut nothing
;Moves the tetra by X and Y
TL_MoveTetra:

    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5

    MOV R2,_TL_MovingTetra
    MOV R3,4

 _TL_MoveTetra_loop:
    ADD R2,4;go to blocks
    MOV R4,[R2+0]
    MOV R5,[R2+2]
    ADD R4,R0
    ADD R5,R0
    MOV [R2+0],R4
    MOV [R2+2],R5
    SUB R3,1
    CMP R3,0
    JNZ _TL_MoveTetra_loop

    POP R5
    POP R4
    POP R3
    POP R2

    RET

TL_TryMoveTetra:

    RET

;Input R0(X) R1(Y)
;OutPut R2(Can/Can't)
;
TL_TryBlock:
    
    CMP R0,0
    JNN PassXMin
    MOV R2,0
    RET
PassXMin:
    MOV R2,10
    CMP R0,R2
    JN PassXMax
    MOV R2,0
    RET
PassXMax:
    CMP R0,0
    JNN PassYMin
    MOV R2,0
    RET
PassYMin:
    MOV R2,20
    CMP R0,R2
    JN PassYMax
    MOV R2,0
    RET
PassYMax:

    PUSH R0
    PUSH R1
    PUSH R3

    MOV R2,_TL_Board
    MOV R3,10
    MUL R1,R3
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
    MOV R4,16
    MOV R6,1
    MOV R7,0
    MOV R8,0

height:
    MOV R2,10


    MOV [_MD_Commands+0CH],R6;Set X
    MOV [_MD_Commands+0AH],R4;Set Y
    MOV R8,R0
width:
    MOV R5,[R0]
    SHL R5,1
    MOV R5,[R1+R5]
    MOV [_MD_Commands+12H],R5;Draw
    MOV [_MD_Commands+12H],R5;Draw
    ADD R0,2

;end width

    SUB R2,1
    CMP R2,0
    JNZ width

;end height

    CMP R7,0
    JZ skip
    SUB R3,1
    MOV R7,-1
    JMP noskip
skip:
    MOV R0,R8
noskip:
    ADD R4,1
    ADD R7,1
    CMP R3,0
    JNZ height

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