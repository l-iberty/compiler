%{
	#include <stdio.h>
	#include <stdlib.h>
	
	void yyerror(char *);
	int yylex(void);
	
	// 符号(变量)表
	// 仅支持 26 个小写字母标识的变量
	int sym[26];
%}

%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/'

%%

program:
	program statement ';'	{ printf("[yacc] program1\n"); }
	| statement ';'			{ printf("[yacc] program2\n"); }
	;

statement:
	expr					{ printf("[yacc] expr: %d\n", $1); }
	| VARIABLE '=' expr		{
								sym[$1] = $3; /* VARIABLE 的语义值 = 变量在 sym[] 中的索引; expr 的语义值 = 变量值 */
								printf("[yacc] assign: %c = %d\n", $1 + 'a', $3);
							}
	;

expr:
	INTEGER					{ printf("[yacc] integer: %d\n", $1); }
	| VARIABLE				{
								$$ = sym[$1]; /* 取 sym[] 中存放的变量值, 附给产生式右端的 expr */
								printf("[yacc] variable: %c\n", $1 + 'a');
							}
	| expr '+' expr			{ $$ = $1 + $3; printf("[yacc] add: %d + %d\n", $1, $3); }
	| expr '-' expr			{ $$ = $1 - $3; printf("[yacc] sub: %d - %d\n", $1, $3); }
	| expr '*' expr			{ $$ = $1 * $3; printf("[yacc] mul: %d * %d\n", $1, $3); }
	| expr '/' expr			{ $$ = $1 / $3; printf("[yacc] div: %d / %d\n", $1, $3); }
	| '(' expr ')'			{ $$ = $2; /* 取()内的表达式的语义值 */ }
	;
	
%%

void yyerror(char *s)
{
	fprintf(stderr, "yacc error: %s\n", s);
}

