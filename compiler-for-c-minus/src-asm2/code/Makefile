.PHONY: clean

YACCFLAGS=	-d
C_LEX_FLAGS=	-lfl
CFLAGS=		$(C_LEX_FLAGS) -g3


LEX_IN=		scanner.l
LEX_OUT=	lex.yy.c
LEX_OBJ=	lex.yy.o

YACC_IN=	parser.y
YACC_OUT=	y.tab.c
YACC_OBJ=	y.tab.o
YACC_HDR=	y.tab.h

TARGET=		asm
OBJS=		$(YACC_OBJ) $(LEX_OBJ) misc.o main.o


$(TARGET): $(OBJS)
	gcc $^ $(CFLAGS) -o $@

$(YACC_OBJ): $(YACC_OUT) $(YACC_HDR)
	gcc $< $(CFLAGS) -c

$(LEX_OBJ): $(LEX_OUT)
	gcc $< $(C_LEX_FLAGS) -c

$(LEX_OUT): $(LEX_IN)
	lex $<

$(YACC_OUT): $(YACC_IN)
	yacc $(YACCFLAGS) $<

misc.o: misc.c
	gcc $< $(CFLAGS) -c

main.o: main.c
	gcc $< $(CFLAGS) -c

clean:
	rm *.o
	rm $(LEX_OUT) $(YACC_OUT) $(YACC_HDR)
