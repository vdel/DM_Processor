SRC = simu.cc
PROG = $(SRC:.cc=)

.PHONY = all clean

all: $(PROG)

$(PROG): %: %.cc
	g++ -O2 -Wall -Wextra -pedantic -ansi $< -L/usr/X11R6/lib -lX11 -o $@

clean:
	rm -f *~ \#*\#
