;not an actual file
;just a small file for the better and bigger main file

PLACE 1000H
stack_end:
    STACK 100H
stack_start:

tab:
;here go labels of the functions that will run on Exceptions Raise
WORD Int0,Int1,Int2,Int3
PLACE 0

init:
    MOV SP,stack_start;Making a stack is needed
    MOV BTE,tab;Telling where the functions labels are
    EI0;Enableing Exceptions 0
    EI1;                     1
    EI2;                     2
    EI3;                     3
    EI ;Enableing Respoding To Said Exceptions
inf:
    ;wait for Exceptions to be raised
    ;do keyboard pulling
    JMP inf

Int0:
    ADD R0,1
    RFE

Int1:
    ADD R1,1
    RFE

Int2:
    ADD R2,1
    RFE

Int3:
    ADD R3,1
    RFE
