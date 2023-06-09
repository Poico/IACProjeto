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

Misspeling After Misspeling

The Project Uses a Library aprouche to ease the develepement of it
SubParts of the project like RNG/MANAGER/INTERRUPTS were made in seperate files
We then used a tool called Merger to merge them toggether to something that pepe can read and run

[===========================DIDAS EXPLAINS IT===========================]

The Benefits of makeing like this is that multiple files can be modified by different users at the same time making develeping easer
We also used Trello to divide tasks Amoung Us to make the work load faster and not clash when two people where wasting time both doing the same thing
To Manage files and sincing bettwen group members we used github

We also did other tool that had an impact on develeping but dont leave a mark on the source code
one was a styling to NotePad++ To also make it easer hilinghting Registers and Comands

[===========================DIDAS MAYBE EXPANDS THIS===========================]

the outher one was a program that could turn small images into somthing that our Media Center Manager could draw to screen
this one end up not being used

(if private > _)[NameSpace]_[FunctionName](_[SubPart])
NameSpace is the acronim of the original files name
ex: MediaCenter > MD / Manager > MAN
functionname is a functionname
ex: DrawRect / PlayMenu
subpart is a jump label within the function it self
ex: width
if the label starts whit a _ then it means its a "private" and should no be called from the outside
ex: _MD_DrawRect_width is something that should not be called
while
ex: MAN_PlayMenu can be called from the outside