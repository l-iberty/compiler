%option yylineno

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include "y.tab.h"

xmlNodePtr createTerminalNode(char* nodeText, char* tagName);
void createXmlFile();
void saveXmlFile();

%}

letter		[a-z|A-Z]
digit		[0-9]
id			{letter}+{digit}*
num			{digit}+
delimiter	";"|","|"("|")"|"["|"]"|"{"|"}"
unary_op	"+"|"-"|"*"|"/"|"%"|"!"|"|"|"&"|"="|">"|"<"
comment		"//".*
whitespace	[ \t\n\r]*

%%

"int"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return INT;
		}
		
"void"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return VOID;
		}

"bool"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return BOOL;
		}
		
"if"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return IF;
		}
		
"else"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return ELSE;
		}
		
"while"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return WHILE;
		}

"break"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return BREAK;
		}

"return"	{
				yylval.node = createTerminalNode(yytext, "KEYWORD");
				return RETURN;
			}
		
"true"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return _TRUE;
		}

"false"	{
			yylval.node = createTerminalNode(yytext, "KEYWORD");
			return _FALSE;
		}

"<="	{
			yylval.node = createTerminalNode(yytext, "RELOP");
			return RELOP_LE; 
		}

">="	{
			yylval.node = createTerminalNode(yytext, "RELOP");
			return RELOP_GE;
		}

"=="	{
			yylval.node = createTerminalNode(yytext, "RELOP");
			return RELOP_E;
		}

"!="	{
			yylval.node = createTerminalNode(yytext, "RELOP");
			return RELOP_NE;
		}
		
"+="	{
			yylval.node = createTerminalNode(yytext, "ADD_ASSIGN");
			return ADD_ASSIGN;
		}
		
"-="	{
			yylval.node = createTerminalNode(yytext, "SUB_ASSIGN");
			return SUB_ASSIGN;
		}
		

{id}	{
				yylval.node = createTerminalNode(yytext, "ID");
				return ID;
		}
				
{num}	{
			yylval.node = createTerminalNode(yytext, "NUM");
			return NUM;
		}

{unary_op}		{
						yylval.node = createTerminalNode(yytext, "UNARY_OP");
						return *yytext;
				}
				
{delimiter}		{
						yylval.node = createTerminalNode(yytext, "UNARY_OP");
						return *yytext;
				}

{comment}		{	/* ignore comment */ }

{whitespace}	{	/* ignore whitespace */ }

.	{
		printf("lex error: undefined text: %s\n", yytext);
		exit(1);
	}

%%

//#define USE_DEFAULT_FILE

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
	yyin = fopen("test.c", "r");
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

