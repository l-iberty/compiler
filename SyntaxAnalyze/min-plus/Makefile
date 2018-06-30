.PHONY: clean

YACCFLAGS=	-d
C_LEX_FLAGS=	-lfl -g
C_XML_FLAGS=	-I/usr/local/include/libxml2 -L/usr/local/lib -lxml2 -lz -lm -g
CFLAGS=		$(C_LEX_FLAGS) $(C_XML_FLAGS)

OBJS=		y.tab.o lex.yy.o misc.o

test: $(OBJS)
	gcc $^ $(CFLAGS) -o $@

y.tab.o: y.tab.c y.tab.h
	gcc $< -c

lex.yy.o: lex.yy.c
	gcc $< $(C_LEX_FLAGS) -c

misc.o: misc.c
	gcc $< $(C_XML_FLAGS) -c

lex.yy.c: lex.l
	lex $<

y.tab.c: yacc.y
	yacc $(YACCFLAGS) $<

clean:
	rm y.tab.[ch]
	rm lex.yy.c
	rm *.o
