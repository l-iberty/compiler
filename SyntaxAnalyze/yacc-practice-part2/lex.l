%{
	#include "y.tab.h"
	void yyerror(char *);
%}

%%
	/* variables */
[a-z]	{
			// 变量名的语义值 = 变量名在 sym[] 中的索引
			yylval = *yytext - 'a';
			printf("[lex] variable: %s\n", yytext);
			return VARIABLE;
		}
		
	/* integers */
[0-9]+	{
			yylval = atoi(yytext);
			printf("[lex] integer: %s\n", yytext);
			return INTEGER;
		}
		
	/* operators & ';' */
[-+()=/*;]		{
					// 语义值 = 字符的 ACSII 码
					printf("[lex] misc: %s\n", yytext);
					return *yytext;
				}

	/* skip whitespace */
[ \t\n]	;

.	{ fprintf(stderr, "invalid character: ascii code #%d", *yytext); }

%%

//#define USE_FILE

int yywrap(void)
{
	return 1;
}

int main(int argc, char *argv[])
{
#ifdef USE_FILE
	if (argc != 2)
	{
		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
		return 1;
	}
	yyin = fopen(argv[1], "r");
	if (yyin == NULL)
	{
		fprintf(stderr, "file error\n");
		return 1;
	}
#else
	printf("enter something, or Ctrl+D to exit...\n");
#endif

	yyparse();
	
#ifdef USE_FILE
	fclose(yyin);
#endif
	return 0;
}
