%{
	#include <stdlib.h>
	#include "y.tab.h"
%}


%%

[a-zA-z]([a-zA-Z]|[0-9])*	{ printf("word: %s\n", yytext); }

"+"	{ return ADD; }

"-" { return SUB; }

"*"	{ return MUL; }

"/"	{ return DIV; }

[0-9]*	{
			yylval = atoi(yytext);
			//printf("digit: %s, %d\n", yytext, yylval);
			return INTEGER;
		}

[ \t\n]	;

.	{
		printf("invalid characters\n");
		exit(1);	
	}

%%

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		printf("Usage: %s <filename>\n", argv[0]);
		return 1;
	}
	
	yyin = fopen(argv[1], "r");
	if (yyin == NULL)
	{
		printf("file error\n");
		return 1;
	}
	
	yyparse();
	
	fclose(yyin);
	return 0;
}
