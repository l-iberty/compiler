.PHONY: clean

C_LEX_FLAGS=	-lfl -c
C_XML_FLAGS=	-I/usr/local/include/libxml2 -L/usr/local/lib -lxml2 -lz -lm -c
C_FLAGS=	-lfl -I/usr/local/include/libxml2 -L/usr/local/lib -lxml2 -lz -lm -o

LexAnalyze: lex.yy.o xmlhelper.o
	gcc $^ $(C_FLAGS) $@

lex.yy.o: lex.yy.c
	gcc $< $(C_LEX_FLAGS)

xmlhelper.o: xmlhelper.c xmlhelper.h
	gcc $< $(C_XML_FLAGS) 

lex.yy.c: *.l
	lex $<

clean:
	rm *.o
