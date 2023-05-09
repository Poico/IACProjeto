;RNG_VAL.asm

;place Before MainLogic

;this is where the RNG value is stored
RNG_ADDRESS EQU 0800H
PLACE RNG_ADDRESS
WORD 01B1EH ;Starting value can be anything