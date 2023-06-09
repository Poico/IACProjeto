; README.txt

; *********************************************************************************
; * Projeto IAC 2022/23 - IST-UL - Versão Final
; * Alunos: Rodrigo Gomes (106644) Diogo Diniz (106196) Tomás Antunes (106265)
; *********************************************************************************


Controls:
-Key 0 is used to start/stop background music
-Key 1 is used to rotate the tetrinos
-Keys 4/6 move the tetrinos left/right respectively
-Key 9 "slams" the tetrino down
-Key D pauses the game
-Key F begins the game

(if private > _)[NameSpace]_[FunctionName](_[SubPart])
NameSpace is the acronim of the original files name
functionname is a functionname
subpart is a jump label within the function it self
if the label starts whit a _ then it means its a "private" and should no be called from the outside