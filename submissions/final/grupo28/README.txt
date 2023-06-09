; README.txt

; *********************************************************************************
; * Projeto IAC 2022/23 - IST-UL - Versão Final
; * Alunos: Rodrigo Gomes (106644) Diogo Diniz (106196) Tomás Antunes (106265)
; *********************************************************************************


The Project uses a Library aproach to ease the develepement of it.
The libraries are:

TetraLogic ;Works with all logic involved in for the game to be playable
ScoreBar 
RNG ;Random Number Genration
MediaDrive ;All functions involved with Media Center
Manager ;All functions that involve UI
Keyboard
Interrupts
Header ; The Header of the file with our names
BCD ; Binary to Decimal

We then used a tool called Merger to merge them together to something that the simulator can read and run.

[===========================DIDAS EXPLAINS IT===========================]

The Benefits of making it like this are that multiple files can be modified by different developers at the same time making developing easier.
We also used Trello to divide tasks AMONG US to make the work more efficient and organized so we could manage our time better
To Manage files and syncing between group members we used github

We also did other tool that had an impact on develeping but dont leave a mark on the source code.
the code highlighting for NotePad++ to make it more readble and easy for the development

[===========================DIDAS MAYBE EXPANDS THIS===========================]

The other one was a program that could turn small images into something that our Media Center Manager could draw to screen
this one ended up not being used

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