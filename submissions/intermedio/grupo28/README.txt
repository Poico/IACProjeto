; README.txt

; *********************************************************************************
; * Projeto IAC 2022/23 - IST-UL - Versão Intermédia
; * Alunos: Rodrigo Gomes (106644) Diogo Diniz (106196) Tomás Antunes (106265)
; *********************************************************************************

Throughout the code there are ";includes" and ";<filename>.asm" comments,
marking the places in code where files where merged. We created a tool
to import code from multiple files into one final file for ease of
source control. The submitted file (Main_merged.asm) is the output of
our program and contains all code developed for the project.

Controls:
-Key 0 is temporarily used to start/stop background music
-Key 1 is to rotate the tetrinos
-Keys 4/6 move the tetrinos left/right respectively
-Key 9 "slams" the tetrino down
-Key D pauses the game
-Key F begins the game

Known issues:
-Right-most column collisions can be inacurate.
-First time starting the code, music might not always play
-Pause doesn't erase score bar nor next tetrino preview
-(not necessarily an issue) Tetramino preview is rotated
-Some tetraminos rotate the opposite way

TODO:
-Patch known issues
-Add score system
-Add fail condition
-"Win" condition (100% score)
-Add full command list to menu
-Add "exit" button
