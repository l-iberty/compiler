%option yylineno

%{

#include <stdio.h>
#include <string.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include "y.tab.h"

xmlNodePtr createTerminalNode(char* nodeText);
void createXmlFile();
void saveXmlFile();

%}

%%

"begin" {
			yylval.node = createTerminalNode(yytext);
			return PRO_BEGIN;
		}

"end"	{
			yylval.node = createTerminalNode(yytext);
			return PRO_END;
		}

"integer function"	{
						yylval.node = createTerminalNode(yytext);
						return INT_FUNC;
					}

"integer"	{
				yylval.node = createTerminalNode(yytext);
				return INTEGER;
			}

"read"		{
				yylval.node = createTerminalNode(yytext);
				return READ;
			}

"write"		{
				yylval.node = createTerminalNode(yytext);
				return WRITE;
			}

"if"		{
				yylval.node = createTerminalNode(yytext);
				return IF;
			}

"then"		{
				yylval.node = createTerminalNode(yytext);
				return THEN;
			}

"else"		{
				yylval.node = createTerminalNode(yytext);
				return ELSE;
			}

[a-zA-Z]+	{
				yylval.node = createTerminalNode(yytext);
				return LETTER;
			}

"("			{
				yylval.node = createTerminalNode(yytext);
				return LPAR; 
			}

")" 		{
				yylval.node = createTerminalNode(yytext);
				return RPAR; 
			}

";" 		{ 
				yylval.node = createTerminalNode(yytext);
				return SEM; 
			}

"-" 		{ 
				yylval.node = createTerminalNode(yytext);
				return SUB; 
			}

"*" 		{ 
				yylval.node = createTerminalNode(yytext);
				return MUL; 
			}

":=" 		{ 
				yylval.node = createTerminalNode(yytext);
				return ASSIGN; 
			}

"<" 		{ 
				yylval.node = createTerminalNode(yytext);
				return L; 
			}

"<=" 		{ 
				yylval.node = createTerminalNode(yytext);
				return LE; 
			}

">" 		{ 
				yylval.node = createTerminalNode(yytext);
				return G; }

">=" 		{ 
				yylval.node = createTerminalNode(yytext);
				return GE; 
			}

"=" 		{ 
				yylval.node = createTerminalNode(yytext);
				return E;
			}

"!=" 		{ 
				yylval.node = createTerminalNode(yytext);
				return NE; 
			}

[0-9]+ 		{ 
				yylval.node = createTerminalNode(yytext);
				return DIGIT; 
			}

.|\n

%%

#define USE_DEFAULT_FILE

int main(int argc, char *argv[])
{
#ifndef USE_DEFAULT_FILE
	if (argc != 2)
	{
		printf("Usage: %s <file_name>\n", argv[0]);
		return 1;
	}
	
	yyin = fopen(argv[1], "r");
#else
	yyin = fopen("input.txt", "r");
#endif // USE_DEFAULT_FILE
	if (yyin == NULL)
	{
		printf("input file %s error\n", argv[1]);
		return 1;
	}
	
	createXmlFile();
	
	yyparse();
	
	saveXmlFile();
	
	fclose(yyin);
	
	return 0;
}

