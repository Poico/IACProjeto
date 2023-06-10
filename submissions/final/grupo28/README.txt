; README.txt

; *******************************************************************************
; * Projeto IAC 2022/23 - IST-UL - Versão Final                                 *
; * Alunos: Rodrigo Gomes (106644) Diogo Diniz (106196) Tomás Antunes (106265)  *
; *******************************************************************************


/==========================\
|=========Libraries========|
\==========================/
The project uses a library aproach for ease of its develepement.
The libraries are:

TetraLogic: Works with all logic related to tetrino movement and collision checking
ScoreBar: Handles the score calculation and displaying, both on the screen and hex displays
RNG: Random Number Generation
MediaDrive: All functions related to the Media Center
Manager: All functions related UI and Menus
Keyboard: All functions that interact with the keyboard and key handling
Interrupts: Configures hardware interrupts and callback functions
Header: The header of the file with our names
BCD: Binary Coded Decimal related functions and drawing to the hex displays


/==========================\
|==========Tools===========|
\==========================/
We also developed external tools to aid in the development of the project, those being:
-Merger
-Styling
-Pallete

[======Merger======]
When we submitted the intermediate version of the project this tool simply pasted file contents where requested.
For example, if in the code there was a statement such as '#include:lib/MediaDrive.asm' the tool would replace that line with the
entire contents of './lib/MediaDrive.asm', granted this file had not been previously included.

For the final version of the project the tool was updated to support 'sections'. These would be place in the code to denote placement in the final source file.
For example, the code found after '#section:equ' would be placed before any code in the 'data' or 'text' sections, to ensure all EQU and variables would be placed
together at the beggining of the final file.

None of the directives written for the Merger tool are included in the final file as they would prevent assembling.

The benefits of making it like this are that multiple files can be modified concurrently by different developers making development and source control easier.
We also used Trello to divide tasks between us to make the work more efficient and organized so we could better manage our time.
To manage files and syncing between group members we used Github.

[======Syntax======]
We made a syntax highlighting extension for Notepad++ to support the PEPE-16 assembly and Macros, as well as the directives for the merger.
This allowed faster recognition of typing errors and greatly improved code readability.

[======Pallete=====]
The other program we made could turn small images into something that our Media Center Drive could draw to screen: Sprites.
This one ended up not being used for the project.


/==========================\
|=======Label naming=======|
\==========================/
All of the labels follow a naming scheme we created at the start of the project so that repeated or unclear labels were not present in the code.
It also helped with legibility since it eases the reading of labels by clearly stating how they work and where they are.

The scheme is as follows:

	[_]<Namespace>_<Name>[_<SubPart>]

Namespace: the acronym of the containing file name
(ex: MediaCenter -> MD; Manager -> MAN)
Name: its the name of the label
(ex: DrawRect / PlayMenu)
SubPart: is a subname of the a bigger system that can be a routine or data
(ex: width in _MD_DrawRect_width; ANG0 in _TL_invL_ANG0)
If the label starts with '_' then it means it is "private" and should not be used outside its corresponding file.
(ex: _MD_DrawRect_width is something that should not be used externally,
while MAN_PlayMenu can be used externally)

/==========================\
|======Known problems======|
\==========================/

Despite having confirmed that the code takes the correct paths and writes to the
appropriate MediaCentre ports, we could not get the muting of the music to work
consistently, and we believe it is a bug in the simulator itself. It works the first
time but from then on it doesn't seem to be functional.
