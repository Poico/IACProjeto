;test_main.asm - Random testing

PLACE 0
entry:
	MOV SP, stack_top

end:
	JMP end

#include:../lib/keyboard.asm
#include:../lib/BCD.asm

PLACE 3800H
STACK 07FEH
PLACE 3FFEH
stack_top:
