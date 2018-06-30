%option yylineno

%{

#include <stdio.h>
#include "y.tab.h"

%}

%%

"begin" { return PRO_BEGIN; }

"end" { return PRO_END; }

"integer function" { return INT_FUNC; }

"integer" { return INTEGER; }

"read" { return READ; }

"write" { return WRITE; }

"if" { return IF; }

"then" { return THEN; }

"else" { return ELSE; }

[a-zA-Z]+ { return LETTER; }

"(" { return LPAR; }

")" { return RPAR; }

";" { return SEM; }

"-" { return SUB; }

"*" { return MUL; }

":=" { return ASSIGN; }

"<" { return L; }

"<=" { return LE; }

">" { return G; }

">=" { return GE; }

"=" { return E; }

"!=" { return NE; }

[0-9]+ { return DIGIT; }

.|\n

%%

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		printf("Usage: %s <file_name>\n", argv[0]);
		return 1;
	}
	
	yyin = fopen(argv[1], "r");
	if (yyin == NULL)
	{
		printf("input file %s error\n", argv[1]);
		return 1;
	}
	
	yyparse();
	fclose(yyin);
	
	return 0;
}

