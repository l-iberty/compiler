.PHONY: clean

CFLAGS=		-lfl
YACCFLAGS=	-d
CC=		gcc
LEX=		lex
YACC=		yacc

test: y.tab.o lex.yy.o
	$(CC) $^ $(CFLAGS) -o $@

y.tab.o: y.tab.c y.tab.h
	$(CC) $< -c

lex.yy.o: lex.yy.c
	$(CC) $< $(CFLAGS) -c

lex.yy.c: lex.l
	$(LEX) $<

y.tab.c: yacc.y
	$(YACC) $(YACCFLAGS) $<

clean:
	rm *.o
	rm y.tab.[ch]
	rm lex.yy.c
