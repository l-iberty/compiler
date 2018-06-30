.PHONY: clean

YACCFLAGS=	-d
C_LEX_FLAGS=	-lfl -g
C_XML_FLAGS=	-I/usr/local/include/libxml2 -L/usr/local/lib -lxml2 -lz -lm -g
CFLAGS=		$(C_LEX_FLAGS) $(C_XML_FLAGS)


LEX_IN=		scanner.l
LEX_OUT=	lex.yy.c
LEX_OBJ=	lex.yy.o

YACC_IN=	parser.y
YACC_OUT=	y.tab.c
YACC_OBJ=	y.tab.o
YACC_HDR=	y.tab.h

TARGET=		parser
OBJS=		lex.o syntax.o $(YACC_OBJ) $(LEX_OBJ)


$(TARGET): $(OBJS)
	gcc $^ $(CFLAGS) -o $@

$(YACC_OBJ): $(YACC_OUT) $(YACC_HDR)
	gcc $< -c

$(LEX_OBJ): $(LEX_OUT)
	gcc $< $(C_LEX_FLAGS) -c

lex.o: lex.c
	gcc $< $(C_XML_FLAGS) -c

syntax.o: syntax.c
	gcc $< $(C_XML_FLAGS) -c

$(LEX_OUT): $(LEX_IN)
	lex $<

$(YACC_OUT): $(YACC_IN)
	yacc $(YACCFLAGS) $<

clean:
	rm $(LEX_OUT) $(YACC_OUT) $(YACC_HDR)
	rm *.o
