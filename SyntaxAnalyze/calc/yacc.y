%{
	#include <stdio.h>
	#include <stdlib.h>
	int yylex(void);
	void yyerror();
%}

%token INTEGER ADD SUB MUL DIV
%left ADD SUB
%left MUL DIV

%%

start: expr		{ printf("expr value = %d\n", $1); }

expr: INTEGER		{ $$ = $1; printf("INTEGER: %d\n", $$); }
| expr ADD expr		{ $$ = $1 + $3; printf("%d + %d = %d\n", $1, $3, $$); }
| expr SUB expr		{ $$ = $1 - $3; printf("%d - %d = %d\n", $1, $3, $$); }
| expr MUL expr		{ $$ = $1 * $3; printf("%d * %d = %d\n", $1, $3, $$); }
| expr DIV expr		{ $$ = $1 / $3; printf("%d / %d = %d\n", $1, $3, $$); }
;

%%

void yyerror(char* str) {
	printf("yacc error: %s\n", str);
}
