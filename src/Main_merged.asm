; Main.asm - Entry point and main code file

	PLACE 0
entry:
	; stack 
	MOV SP, stack_top
	
	CALL IT_SetupInterrupts
	CALL MD_InitMedia
	MOV R0, 0
	CALL MD_SetBack
	
poll_loop:
	CALL KB_PollKey
	JMP poll_loop
	
end:
	JMP end
	

; includes
; Interrupts.asm - Interrupt setup and handlers
; External clocks:
; 0 - draw
; 1 - animation/RNG
; 2 - gravity
; 3 - input

_IT_CLR_TV_TD 	EQU 0FF6FH	; Bitmask to clear TV & TD
_IT_SET_INTS 	EQU 00F80H	; Bitmask to set IE and IE# (0-3)
_IT_CLR_GINTS 	EQU 0F8FFH	; Bitmask to clear game interrupts IE# (0-2)
_IT_SET_GINTS	EQU 00700H	; Bitmask to set game interrupts IE# (0-2)

; ScoreBar.asm - Functions to draw an animated score bar

WIDTH		EQU 32
HEIGHT		EQU 64
BWIDTH 		EQU 4
BHEIGHT		EQU 12
CORNER_X	EQU 25
CORNER_Y	EQU 18
MAX			EQU 100

;MediaDrive.asm

MD_TestPalette:
;	0	  1	  2	  3	  4
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
;		0	  1	  	2	  	3	  	4	  	5	  	6	  7	  	8	  9	  	A	  	B	  	C	  	D	  E	  	F
WORD 07B6FH,02492H,073E7H,079E7H,049EDH,079CFH,07BCFH,04927H,07BEFH,049EFH,05BEFH,03AEBH,0624EH,03B6BH,073CFH,013CFH
MD_Commands EQU 6000H
_MD_Memmory EQU 8000H
_MD_Width EQU 32
_MD_Height EQU 64

;Input nothing
;Output nothing
;Clear screen and removes warning
MD_InitMedia:
	PUSH R0
	MOV R0,1
	MOV [MD_Commands + 10H],R0;AutoMov enabled some draw call need this on
	MOV [MD_Commands + 02H],R0;clear screen(s)
	MOV [MD_Commands + 40H],R0;remove warning
	POP R0
	RET

;Input nothing
;Output nothing
;Clear screen
MD_ClearScreen:
	MOV [MD_Commands + 02H],R0 ;clear screen(s)
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
	MOV [MD_Commands + 12H],R0 ;Draw And Move
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
	MOV [MD_Commands+0CH],R0;Set X
	MOV [MD_Commands+0AH],R1;Set Y
	MOV [MD_Commands+12H],R2;Draw
	RET

;Input R0(ID)
;Output nothing
;Sets Background
MD_SetBack:
	MOV [MD_Commands+42H],R0 ;Set Background with the adress of MediaCenter plus the command to set background
	RET
	
;Input R0(X) R1(Y) R2(width) R3(height) R4(Color)
;Output nothing
;Draws a rectagle
MD_DrawRect:

	PUSH R1 
	PUSH R3 
	PUSH R5 

_MD_DrawRect_height:
	MOV [MD_Commands+0CH],R0;Set X
	MOV [MD_Commands+0AH],R1;Set Y
	MOV R5,R2

_MD_DrawRect_width:
	MOV [MD_Commands+12H],R4;Draw
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
	MOV [MD_Commands+0CH],R0;Set X
	MOV [MD_Commands+0AH],R1;Set Y
	MOV R10,R4

_MD_DrawSprite_widthloop:
	MOV R6,[R2];get sheet

	;1 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Commands+12H],R9;Draw
	SHR R6,4;

	;2 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Commands+12H],R9;Draw
	SHR R6,4;

	;3 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Commands+12H],R9;Draw
	SHR R6,4;

	;4 pixel

	MOV R7,R6
	AND R7,R8
	SHL R7,1
	MOV R9,[R7+R3]
	MOV [MD_Commands+12H],R9;Draw

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
	MOV [MD_Commands+0CH],R0;Set X
	MOV [MD_Commands+0AH],R1;Set Y
	MOV R7,3
_MD_DrawHex_WidthLoop:
	SHR R4,1
	JNC _MD_DrawHex_NoCarry
	MOV [MD_Commands+12H],R2;Draw Color
	JMP _MD_DrawHex_Move
_MD_DrawHex_NoCarry:
	MOV [MD_Commands+12H],R6;Draw nothing
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
	MOV [MD_Commands+5AH],R0
	RET


;Input R0(ID)
;Output nothing
;Plays a video/sound on loop
MD_Loop:
	MOV [MD_Commands+5CH],R0
	RET


;Input R0(ID)
;Output nothing
;pauses a video/sound
MD_Pause:
	MOV [MD_Commands+5EH],R0
	RET

;Input R0(ID)
;Output nothing
;unpauses a video/sound
MD_Unpause:
	MOV [MD_Commands+60H],R0
	RET

;Input R0(ID)
;Output nothing
;Stops a video/sound
MD_Stop:
	MOV [MD_Commands+66H],R0
	RET
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
	PUSH R1
	MOV R1, _BC_HexOut	; Display pointer
	MOV [R1], R0		; Write value
	POP R1
	RET

; Draws score bar and writes to hex display
SB_DrawSB:
	PUSH R1				; <draw call args>
	PUSH R2				; <draw call args>
	PUSH R3				; <draw call args>
	PUSH R4				; <draw call args>
	PUSH R5				; fillPixels / colorTmp
	PUSH R6				; maxX / conversion bkp
	PUSH R7				; maxY
	PUSH R10			; aux
	
	MOV R0, [SB_Score]	; Get score
	
_SB_DrawSB_writePercent:
	MOV R10, 100
	MUL R0, R10			; R0 = (R0 * 100) / MAX (to get percent)
	MOV R10, MAX
	DIV R0, R10
	
	CALL BC_ToBCD		; Get percent BCD
	MOV R0, R1			; (mov to R0 for call)
	CALL BC_WriteToDisp	; Print BCD to hex
	
_SB_DrawSB_calcFill:
	MOV R0, [SB_Score]	; Get score again
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
	
_SB_Color:
	WORD 0FF00H
	
SB_Score:
	WORD 50
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


; Polls keyboard and sets up the key
KB_PollKey:
	PUSH R0
	PUSH R1						; Press_Handles base pointer
	PUSH R2						; Hold_Handles base pointer
	PUSH R3						; Auxiliar
	
	MOV R1, _KB_Press_Handles	; Load pointers
	MOV R2, _KB_Hold_Handles
	
_KB_PollKey_start:
	CALL KB_GetKey
	
	CMP R0, 0FFFFH					; Check for empty key
	JEQ _KB_PollKey_end				; Skip if empty
	
	SHL R0, 1						; Multiply by 2 (word size)
	
_KB_PollKey_hold:
	MOV R3, [_KB_NextKeyHoldHandle] ; Check for handle already set
	TEST R3, R3						; (Update Z flag)
	JNE _KB_PollKey_press			; Ignore if handle is set
	
	MOV R3, [R2 + R0]				; Get handle
	MOV [_KB_NextKeyHoldHandle], R3	; Set next handle

_KB_PollKey_press:
	MOV R3, [_KB_NextKeyPressHandle]; Check for handle already set
	TEST R3, R3						; (Update Z flag)
	JNE _KB_PollKey_end				; Ignore if handle is set
	
	MOV R3, [_KB_LastKeyPressed]	; Check if key pressed changed
	CMP R0, R3
	JEQ _KB_PollKey_end				; Skip if press didn't change
	
	MOV R3, [R1 + R0]				; Get handle
	MOV [_KB_NextKeyPressHandle], R3; Set next handle
	
_KB_PollKey_end:
	MOV [_KB_LastKeyPressed], R0	; Update last key pressed

	POP R3
	POP R2
	POP R1
	POP R0
	RET


; Polls keyboard and executes assigned functions
KB_DoHandles:
	PUSH R0	; Handle pointer
	
	
_KB_DoHandles_hold:
	MOV R0, [_KB_NextKeyHoldHandle]	; Load handle pointer
	TEST R0, R0						; (Update Z flag)
	JEQ _KB_DoHandles_press			; Skip if NULL
	CALL R0							; Call handle

_KB_DoHandles_press:
	MOV R0, [_KB_NextKeyPressHandle]; Load handle pointer
	TEST R0, R0						; (Update Z flag)
	JEQ _KB_DoHandles_end			; Skip if NULL
	CALL R0							; Call handle
	
_KB_DoHandles_end:
	XOR R0, R0						; Reset handle pointers
	MOV [_KB_NextKeyHoldHandle], R0
	MOV [_KB_NextKeyPressHandle], R0

	POP R0
	RET
	

_KB_Press_Handles:
	WORD	0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0
			
_KB_Hold_Handles:
	WORD	0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0

_KB_LastKeyPressed:
	WORD 0
	
_KB_NextKeyPressHandle:
	WORD 0
_KB_NextKeyHoldHandle:
	WORD 0

IT_SetupInterrupts:
	PUSH R0
	PUSH R1
	
	MOV BTE, _IT_interrupt_vectors	; load interrupt vector table
	MOV R0, RE
	MOV R1, _IT_CLR_TV_TD			; Clear TV & TD
	AND R0, R1
	MOV R1, _IT_SET_INTS			; Set IE and IE# (0-3)
	OR R0, R1
	MOV RE, R0
	
	POP R1
	POP R0
	RET


IT_DisableGameInterrupts:
	PUSH R0
	MOV R0, _IT_CLR_GINTS			; Load bitmask
	AND RE, R0						; Clear interrupt bits
	POP R0
	RET


IT_EnableGameInterrupts:
	PUSH R0
	MOV R0, _IT_SET_GINTS			; Load bitmask
	OR RE, R0						; Set interrupts bits
	POP R0
	RET


_IT_INT0:
_IT_drawINT:
	CALL SB_DrawSB
	RFE
	
_IT_INT1:
_IT_animationINT:
	CALL SB_UpdateColor
	RFE
	
_IT_INT2:
_IT_gravityINT:
	RFE
	
_IT_INT3:
_IT_inputINT:
	CALL KB_DoHandles
	RFE
	
_IT_EXCESSO:
_IT_DIV0:
_IT_Discard:
	RFE
	
_IT_COD_INV:
	RFE
	
_IT_D_DESALINHADO:
	RFE
	
_IT_I_DESALINHADO:
	RFE

_IT_interrupt_vectors:
	WORD _IT_INT0, _IT_INT1, _IT_INT2, _IT_INT3,
		_IT_EXCESSO, _IT_DIV0, _IT_COD_INV, _IT_D_DESALINHADO, _IT_I_DESALINHADO

; stack
	PLACE 3800H
	STACK 07FEH
	PLACE 3FFEH
stack_top:
