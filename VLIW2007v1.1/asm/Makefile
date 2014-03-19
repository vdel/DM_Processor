
.PHONY = all clean

all: asm dasm


asm:  asm.cc
	g++ -Wall $< -o $@


dasm:  de_asm.c
	gcc -Wall $< -o $@




clean:
	rm -f *~ \#*\# *.o
