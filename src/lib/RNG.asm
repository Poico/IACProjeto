; RNG.asm

;this is where the RNG value is stored
RNG_ADDRESS:
PLACE RNG_ADDRESS
WORD 01B1EH ;Starting value can be anything

;Input Nothing
;Output R0 random value
;Steps The RNG value
RNG_STEP:

	PUSH R1;RNG_ADDRESS
	PUSH R2;Tmp Value Holder

	MOV R1,RNG_ADDRESS
	MOV R0,[R1];Aquire RNG Value From Memory

	MOV R2,R0 ;R2 = R0
	SHR R2,7  ;R2 >> 7
	XOR R0,R2 ;R0 ^= R2

	MOV R2,R0 ;R2 = R0
	SHL R2,3  ;R2 << 3
	XOR R0,R2 ;R0 ^= R2

	MOV R2,R0 ;R2 = R0
	SHR R2,8  ;R2 >> 8
	XOR R0,R2 ;R0 ^= R2

	MOV [R1],R0 ;Put New Rng Value Back into Memory

	POP R2;Restore
	POP R1

	RET
