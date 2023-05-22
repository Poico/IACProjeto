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
	;CALL MD_ClearScreen
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

;MediaDrive.asm

MD_TestPalette:
;    0      1      2      3      4
WORD 0FFFFH,00000H,0F000H,0FF00H,0F0DFH
MD_TestSprite:
WORD 00007H,00020H
,00000H,01100H,01111H,01111H,01111H,01111H,01111H
,02220H,01100H,00111H,00000H,00000H,01111H,01111H
,00020H,01102H,00011H,03333H,00333H,01110H,01111H
,02220H,01100H,03001H,03333H,03333H,01100H,01111H
,00020H,01102H,03300H,03333H,03333H,01003H,01111H
,02220H,01100H,03330H,03333H,03333H,01033H,01111H
,00000H,01100H,03330H,03333H,03333H,00033H,01000H
,02220H,01100H,04440H,04444H,03333H,03333H,01033H
,00020H,01102H,04440H,04444H,03334H,03333H,01033H
,02220H,01100H,04440H,04444H,03334H,03333H,01033H
,00020H,01102H,04440H,04444H,03334H,03333H,01033H
,00000H,01100H,04440H,04444H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,02200H,01100H,03330H,03333H,03333H,03333H,01033H
,00000H,01100H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,03333H,01033H
,00020H,01102H,03330H,03333H,03333H,00033H,01000H
,02220H,01102H,03330H,03333H,03333H,01033H,01111H
,00020H,01102H,03330H,03333H,03333H,01033H,01111H
,00000H,01100H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,03330H,00003H,03300H,01033H,01111H
,01111H,01111H,00000H,00000H,00000H,01000H,01111H
_MD_Glyphs:
;    0      1      2      3      4      5      6      7      8      9      A      B      C      D      E      F
WORD 07B6FH,02492H,073E7H,079E7H,049EDH,079CFH,07BCFH,04927H,07BEFH,049EFH,05BEFH,03AEBH,0624EH,03B6BH,073CFH,013CFH
_MD_Commands EQU 6000H
_MD_Memmory EQU 8000H
_MD_Width EQU 32
_MD_Height EQU 64

;Input nothing
;Output nothing
;Clear screen and removes warning
MD_InitMedia:
    PUSH R0
    MOV R0,1
    MOV [_MD_Commands + 10H],R0;AutoMov enabled some draw call need this on
    MOV [_MD_Commands + 02H],R0;clear screen(s)
    MOV [_MD_Commands + 40H],R0;remove warning
    POP R0
    RET

;Input nothing
;Output nothing
;Clear screen
MD_ClearScreen:
    MOV [_MD_Commands + 02H],R0 ;clear screen(s)
    RET

;Input R0(Color)
;Output nothing
;Fills the background whit a color
;[WARNING:TALK TO TEACHER ABOUT THE N-PIXEL THING]
;Best to not use this
MD_ColorBack:

    PUSH R1
    PUSH R2

    MOV R1,_MD_Width
    MOV R2,_MD_Height
    MUL R1,R2 ;Get Total Pixel Count
_MD_ColorBack_loop:
    MOV [_MD_Commands + 12H],R0 ;Draw And Move
    SUB R0,1
    CMP R0,0
    JNZ _MD_ColorBack_loop

    POP R2
    POP R1

    RET


;Input R0(X) R1(Y) R2(Color)
;Output nothing
;Draws a pixel
MD_DrawPixel:
    MOV [_MD_Commands+0CH],R0;Set X
    MOV [_MD_Commands+0AH],R1;Set Y
    MOV [_MD_Commands+12H],R2;Draw
    RET

;Input R0(ID)
;Output nothing
;Sets Background
MD_SetBack:
    MOV [_MD_Commands+42H],R0;Bruh
    RET

;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
;Output nothing
;Draws a rectagle
MD_DrawRect:

    PUSH R1 
    PUSH R3 
    PUSH R5 

_MD_DrawRect_height:
    MOV [_MD_Commands+0CH],R0;Set X
    MOV [_MD_Commands+0AH],R1;Set Y
    MOV R5,R2

_MD_DrawRect_width:
    MOV [_MD_Commands+12H],R4;Draw
    SUB R5,1
    CMP R5,0
    JNZ _MD_DrawRect_width

    SUB R3,1
    ADD R1,1
    CMP R3,0
    JNZ _MD_DrawRect_height

    POP R5
    POP R3
    POP R1

    RET

;Input R0(X) R1(Y) R2(Sprite Adress) R3(Sprite Pallet)
;Output nothing
;Draws A Sprite From and Adress
MD_DrawSprite:

    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10

    MOV R8,0FH;MASK
    MOV R4,[R2 + 0];get width
    MOV R5,[R2 + 2];get height
    ADD R2,4;set to the sheet area

_MD_DrawSpriteH_HeightLoop:
    MOV [_MD_Commands+0CH],R0;Set X
    MOV [_MD_Commands+0AH],R1;Set Y
    MOV R10,R4

_MD_DrawSprite_widthloop:
    MOV R6,[R2];get sheet

    ;1 pixel

    MOV R7,R6
    AND R7,R8
    SHL R7,1
    MOV R9,[R7+R3]
    MOV [_MD_Commands+12H],R9;Draw
    SHR R6,4;

    ;2 pixel

    MOV R7,R6
    AND R7,R8
    SHL R7,1
    MOV R9,[R7+R3]
    MOV [_MD_Commands+12H],R9;Draw
    SHR R6,4;

    ;3 pixel

    MOV R7,R6
    AND R7,R8
    SHL R7,1
    MOV R9,[R7+R3]
    MOV [_MD_Commands+12H],R9;Draw
    SHR R6,4;

    ;4 pixel

    MOV R7,R6
    AND R7,R8
    SHL R7,1
    MOV R9,[R7+R3]
    MOV [_MD_Commands+12H],R9;Draw

    ADD R2,2
    SUB R10,1
    CMP R10,0
    JNZ _MD_DrawSprite_widthloop
    
    ADD R1,1
    SUB R5,1
    CMP R5,0
    JNZ _MD_DrawSpriteH_HeightLoop

    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R2
    POP R1

    RET

;Input R0(X) R1(Y) R2(Color) R3(number)
;Output nothing
;Draws A Numberic Glyph From and Adress
MD_DrawHex:

    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R6
    PUSH R7
    PUSH R8

    MOV R6,_MD_Glyphs
    SHL R3,1
    MOV R4,[R3 + R6];load GLYPHS
    MOV R6,0000H
    MOV R8,5
_MD_DrawHex_HeightLoop:
    MOV [_MD_Commands+0CH],R0;Set X
    MOV [_MD_Commands+0AH],R1;Set Y
    MOV R7,3
_MD_DrawHex_WidthLoop:
    SHR R4,1
    JNC _MD_DrawHex_NoCarry
    MOV [_MD_Commands+12H],R2;Draw Color
    JMP _MD_DrawHex_Move
_MD_DrawHex_NoCarry:
    MOV [_MD_Commands+12H],R6;Draw nothing
_MD_DrawHex_Move:
    SUB R7,1
    CMP R7,0
    JNZ _MD_DrawHex_WidthLoop
    ADD R1,1
    SUB R8,1
    CMP R8,0
    JNZ _MD_DrawHex_HeightLoop

    POP R8
    POP R7
    POP R6
    POP R4
    POP R3
    POP R1

    RET

;Input R0(ID)
;Output nothing
;Plays a video/sound
MD_Play:
    MOV [_MD_Commands+5AH],R0
    RET

;Input R0(ID)
;Output nothing
;Plays a video/sound on loop
MD_Loop:
    MOV [_MD_Commands+5CH],R0
    RET

;Input R0(ID)
;Output nothing
;pauses a video/sound
MD_Pause:
    MOV [_MD_Commands+5EH],R0
    RET

;Input R0(ID)
;Output nothing
;unpauses a video/sound
MD_Unpause:
    MOV [_MD_Commands+60H],R0
    RET

;Input R0(ID)
;Output nothing
;Stops a video/sound
MD_Stop:
    MOV [_MD_Commands+66H],R0
    RET
; ScoreBar.asm - Functions to draw an animated score bar

WIDTH		EQU 32
HEIGHT		EQU 64
BWIDTH 		EQU 4
BHEIGHT		EQU 12
CORNER_X	EQU 25
CORNER_Y	EQU 18
MAX			EQU 100

; BCD.asm - Binary Coded Decimal library

_BC_HexOut EQU 0A000H

;returns value of R0 in R1 as BCD
BC_ToBCD:
	PUSH R0
					; Build BCD directly to R1
	PUSH R2			; Remainder divider
	PUSH R3			; Remainder store
	PUSH R4			; Iter counter
	
	XOR R1, R1		; Clear output
	MOV R2, 10000	; Initialize clamp divider
	MOD R0, R2		; Clamp input to allowed values
	
	MOV R2, 10		; Initialize divider
	MOV R4, 4		; Initialize counter
	
	
_BC_ToBCD_loop:
	SHR R1, 4		; Shift output to clear space
	MOV R3, R0		; Copy input
	MOD R3, R2		; Get %10
	SHL R3,	12		; Shift value to highest 4 bits
	ADD R1, R3		; Add to output
	DIV R0, R2		; Divide (shift) input
	SUB R4, 1		; Decrement counter
	JNZ _BC_ToBCD_loop
	
_BC_ToBCD_end:
	POP R4
	POP R3
	POP R2
	POP R0
	RET
	
	
;Write R0 to hexadecimal display
BC_WriteToDisp:
	PUSH R0
	MOV R0, _BC_HexOut	; Display pointer
	MOV [R0], R1		; Write value
	POP R0
	RET

; score in R0
SB_DrawSB:
	PUSH R0				; make a backup
	PUSH R1				; <draw call args>
	PUSH R2				; <draw call args>
	PUSH R3				; <draw call args>
	PUSH R4				; <draw call args>
	PUSH R5				; fillPixels / colorTmp
	PUSH R6				; maxX / conversion bkp
	PUSH R7				; maxY
	PUSH R10			; aux
	
_SB_DrawSB_writePercent:
	MOV R6, R0			; backup
	MOV R10, 100
	MUL R0, R10			; R0 = (R0 * 100) / MAX (to get percent)
	MOV R10, MAX
	DIV R0, R10
	
	CALL BC_ToBCD
	CALL BC_WriteToDisp
	
	MOV R0, R6			; restore
	
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
; keyboard.asm - Keyboard interfacing functions

_KB_KEYO	EQU 0C000H ; write to test
_KB_KEYI	EQU 0E000H ; read to check

;returns first pressed key in R0
KB_GetKey:
	PUSH R1 	; keyboard output pointer (write test)
	PUSH R2 	; keyboard input pointer (read key)
	PUSH R3 	; current bit for test
	PUSH R4 	; test bit shift counter
	PUSH R5		; bit mask & R0 shift counter

	MOV R1, _KB_KEYO
	MOV R2, _KB_KEYI
	MOV R3, 1
	XOR R4, R4
	MOV R5, 0FH
	
_KB_GetKey_loop:
	MOVB [R1], R3		; put test bit
	MOVB R0, [R2]		; read mask
	AND R0, R5			; mask first 4 bits
	CMP R0, 0			; MOVB doesn't affect flags
	JNE _KB_GetKey_dec	; found a key press
	SHL R3, 1			; shift test bit
	ADD R4, 1			; increment shift counter
	CMP R4, 4			; check loop end (4 bit shifts)
	JNE _KB_GetKey_loop ; repeat loop
	MOV R0, 0FFFFH		; -1 for empty
	JMP _KB_GetKey_end
	
_KB_GetKey_dec: 		; decode
	XOR R5, R5			; R5 = 0
	
_KB_GetKey_dlp:			; get bit position
	ADD R5, 1			; R5++
	SHR R0, 1			; R0 >>= 1
	JNE _KB_GetKey_dlp	; while (R0) goto _KB_GetKey_dlp

_KB_GetKey_df:
	SUB R5, 1			; R5-- (it's in [1,4])
	SHL R4, 2			; R0 = (R4 << 2) | R5
	OR R5, R4
	MOV R0, R5
	
_KB_GetKey_end:
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET

;returns non-zero in R1 if the key specified in R0 is pressed
KB_IsKeyPressed:
	MOV R1, R0
	CALL KB_GetKey
	CMP R0, R1
	MOV R1, R0
	JEQ _KB_IsKeyPressed_end
	XOR R1, R1
	
_KB_IsKeyPressed_end:
	RET

PLACE 3800H
STACK 07FEH
PLACE 3FFEH
stack_top:
