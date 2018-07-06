%option yylineno

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include "lex.h"
#include "syntax.h"
#include "y.tab.h"

int id;
extern xmlNodePtr g_symroot;

%}

letter		[a-z|A-Z]
digit		[0-9]
id		{letter}+{digit}*
num		{digit}+
delimiter	";"|","|"("|")"|"["|"]"|"{"|"}"
unary_op	"+"|"-"|"*"|"/"|"%"|"!"|"|"|"&"|"="|">"|"<"
comment		"//".*
whitespace	[ \t\n\r]*

%%

"int"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($INT, NONE);
		return INT;
	}
		
"void"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($VOID, NONE);
		return VOID;
	}

"bool"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($BOOL, NONE);
		return BOOL;
	}
		
"if"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($IF, NONE);
		return IF;
	}
		
"else"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($ELSE, NONE);
		return ELSE;
	}
		
"while"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($WHILE, NONE);
		return WHILE;
	}

"break"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($BREAK, NONE);
		return BREAK;
	}

"return"	{
			yylval.node = create_terminal_node(yytext, "KEYWORD");
			add_binary_formula($RETURN, NONE);
			return RETURN;
		}
		
"true"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($_TRUE, NONE);
		return _TRUE;
	}

"false"	{
		yylval.node = create_terminal_node(yytext, "KEYWORD");
		add_binary_formula($_FALSE, NONE);
		return _FALSE;
	}

"<="	{
		yylval.node = create_terminal_node(yytext, "RELOP");
		add_binary_formula($LE, NONE);
		return RELOP_LE; 
	}

">="	{
		yylval.node = create_terminal_node(yytext, "RELOP");
		add_binary_formula($GE, NONE);
		return RELOP_GE;
	}

"=="	{
		yylval.node = create_terminal_node(yytext, "RELOP");
		add_binary_formula($E, NONE);
		return RELOP_E;
	}

"!="	{
		yylval.node = create_terminal_node(yytext, "RELOP");
		add_binary_formula($NE, NONE);
		return RELOP_NE;
	}
		
"+="	{
		yylval.node = create_terminal_node(yytext, "ADD_ASSIGN");
		add_binary_formula($ADD_ASSIGN, NONE);
		return ADD_ASSIGN;
	}
		
"-="	{
		yylval.node = create_terminal_node(yytext, "SUB_ASSIGN");
		add_binary_formula($SUB_ASSIGN, NONE);
		return SUB_ASSIGN;
	}
		

{id}	{
		yylval.node = create_terminal_node(yytext, "ID");
		
		// 同一个符号不会被重复添加进符号表
		// if (!find_node(g_symroot, BAD_CAST(yytext)))
		// `find_node()` 不再使用
		if (find_symbol(yytext) == NONE)
		{
			add_to_symboltable(yytext, $IDENTIFIER);
		}
		add_binary_formula($IDENTIFIER, find_symbol(yytext));
		
		return ID;
	}
				
{num}	{
		yylval.node = create_terminal_node(yytext, "NUM");

		if (find_symbol(yytext) == NONE)
		{
			add_to_symboltable(yytext, $CONSTANT);
		}
		add_binary_formula($CONSTANT, find_symbol(yytext));
		
		return NUM;
	}

{unary_op}	{
			yylval.node = create_terminal_node(yytext, "UNARY_OP");
			add_binary_formula(*yytext, NONE);
			return *yytext;
		}
				
{delimiter}	{
			yylval.node = create_terminal_node(yytext, "UNARY_OP");
			add_binary_formula(*yytext, NONE);
			return *yytext;
		}

{comment}		{ /* ignore comment */ }

{whitespace}	{ /* ignore whitespace */ }

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
	
	create_lexical_xml_file();
	create_syntax_xml_file();
	
	yyparse();
	
	save_syntax_xml_file();
	save_lexical_xml_file();
	
	fclose(yyin);
	
	return 0;
}

