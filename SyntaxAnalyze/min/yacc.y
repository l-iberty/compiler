%{

#include <stdio.h>

int yylex(void);
void yyerror(char *err);

extern int yylineno;
extern char *yytext;

%}

%token PRO_BEGIN PRO_END		/* 'begin', 'end' */
%token SEM				/* ';' */
%token LPAR RPAR		/* '(', ')' */
%token INTEGER			/* 'integer' */
%token LETTER DIGIT
%token INT_FUNC			/* 'integer function' */
%token READ				/* 'read' */
%token WRITE			/* 'write' */
%token IF				/* 'if' */
%token THEN				/* 'then' */
%token ELSE				/* 'else' */
%token ASSIGN			/* ':=' */
%token L				/* '<'　*/
%token LE				/* '<=' */
%token G				/* '>' */
%token GE				/* '>=' */
%token E				/* '=' */
%token NE				/* '!=' */
%token SUB				/* '-' */
%token MUL				/* '*' */

%left SUB
%left MUL


%%

start: program { printf("done\n"); }
;

program:
	sub_program
;

sub_program:
	PRO_BEGIN def_stmt_list SEM exec_stmt_list PRO_END
;

def_stmt_list:
	def_stmt
	| def_stmt_list SEM def_stmt
;

def_stmt:
	var_def
	| func_def
;

var_def:
	INTEGER var
;

var: id
;

id:
	LETTER
	| id LETTER
	| id DIGIT
;

func_def:
	INT_FUNC id LPAR param RPAR SEM func_body
;

param:
	var
;

func_body:
	PRO_BEGIN def_stmt_list SEM exec_stmt_list PRO_END
;

exec_stmt_list:
	exec_stmt
	| exec_stmt_list SEM exec_stmt
;

exec_stmt:
	read_stmt
	| write_stmt
	| assign_stmt
	| condition_stmt
;

read_stmt:
	READ LPAR var RPAR
;

write_stmt:
	WRITE LPAR var RPAR
;

assign_stmt:
	var ASSIGN expr
;

expr:
	expr SUB item
	| item
;

item:
	item MUL factor
	| factor
;

factor:
	var
	| const
	| func_call
;

const:
	unsigned_int
;

unsigned_int:
	DIGIT
	| unsigned_int DIGIT
;

func_call:
	id LPAR expr RPAR
;

condition_stmt:
	IF con_stmt THEN exec_stmt ELSE exec_stmt
;

con_stmt:
	expr rela_op expr
;

rela_op:
	L | LE | G | GE | E | NE
;


%%

void yyerror(char *err)
{
	printf("yacc error: %s\n", err);
	printf("line: %d, before \"%s\"\n", yylineno, yytext);
}

