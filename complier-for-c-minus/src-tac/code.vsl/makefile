#
# A combined Makefile to build the VC compiler, VAS assembler and VAM
# simulator.
#
#    make <component>
#
# where component is vc, vas or vam as appropriate.
#
#
# Modifications:
# ==============
#
# 14 Jan 96: Unix version of the combined makefile for 2nd edition publication


# Specify the compiler, scanner and parser generators and the flags

CC    = gcc
YACC  = yacc
LEX   = flex
CP    = cp
RM    = rm -f

# Some associated file names

YACCOUT = y.tab.c
YACCHDR = y.tab.h
LEXOUT  = lex.yy.c

# Specify some flags

CFLAGS    = -g -ansi -pedantic
YACCFLAGS = -d -y
LEXFLAGS  = 
LDFLAGS   = -ly -lfl

# Now the rules for generating one from the other

.y.c:
.y.h:
	$(YACC) $(YACCFLAGS) $*.y
	$(CP) $(YACCOUT) $*.c
	$(CP) $(YACCHDR) $*.h
	$(RM) $(YACCOUT)
	$(RM) $(YACCHDR)

.l.c:
	$(LEX) $(LEXFLAGS) $*.l
	$(CP) $(LEXOUT) $*.c
	$(RM) $(LEXOUT)

.c.o:
	$(CC) -c $(CFLAGS) $*.c


# The compiler files involved

HDRS = vc.h \
       parser.h

CSRCS = main.c \
        cg.c

SRCS = $(CSRCS) \
       scanner.c \
       parser.c

OBJS = main.o \
       parser.o \
       scanner.o \
       cg.o


# Create everything for Unix

unix: vc vas vam disasm


# Create a new compiler

vc: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o vc


# Create a new VAS assembler

vas: vas.o
	$(CC) $(CFLAGS) $^ -o $@


# Create a new VAM simulator

vam: vam.o
	$(CC) $(CFLAGS) $^ -o $@

disasm:disasm.o
	$(CC) $(CFLAGS) $^ -o $@

# Compiler source file dependencies


parser.c parser.h: parser.y
scanner.c: scanner.l
main.o: main.c vc.h parser.h
scanner.o: scanner.c vc.h parser.h
parser.o: parser.c vc.h parser.h
cg.o: cg.c vc.h


# Assembler source file dependencies

vas.c vas.h: vas.y
vas.o: vas.h

clean:
	rm -f *.o vc vas vam disasm
