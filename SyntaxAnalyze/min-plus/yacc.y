%{

#include <stdio.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

int yylex(void);
void yyerror(char *err);

xmlNodePtr createNonterminalNode(char* nodeText);
void addChild(xmlNodePtr parent, int num, ...);

extern int			yylineno;
extern char			*yytext;
extern xmlDocPtr	doc;

%}

%union {
	xmlNodePtr node;
};

/* 非终结符 */
%type <node> program
%type <node> sub_program
%type <node> def_stmt_list
%type <node> def_stmt
%type <node> exec_stmt_list
%type <node> exec_stmt
%type <node> read_stmt
%type <node> write_stmt
%type <node> assign_stmt
%type <node> condition_stmt
%type <node> var_def
%type <node> func_def
%type <node> func_body
%type <node> func_call
%type <node> param
%type <node> condition_expr
%type <node> calc_expr
%type <node> var
%type <node> id
%type <node> letter
%type <node> digit
%type <node> item
%type <node> factor
%type <node> const
%type <node> unsigned_int
%type <node> rela_op

/* 终结符 */
%token <node> PRO_BEGIN		/* 'begin' */
%token <node> PRO_END		/* 'begin' */
%token <node> SEM			/* ';' */
%token <node> LPAR RPAR		/* '(', ')' */
%token <node> INTEGER		/* 'integer' */
%token <node> LETTER		/* [a-zA-Z] */
%token <node> DIGIT			/* [0-9] */
%token <node> INT_FUNC		/* 'integer function' */
%token <node> READ			/* 'read' */
%token <node> WRITE			/* 'write' */
%token <node> IF			/* 'if' */
%token <node> THEN			/* 'then' */
%token <node> ELSE			/* 'else' */
%token <node> ASSIGN		/* ':=' */
%token <node> L				/* '<'　*/
%token <node> LE			/* '<=' */
%token <node> G				/* '>' */
%token <node> GE			/* '>=' */
%token <node> E				/* '=' */
%token <node> NE			/* '!=' */
%token <node> SUB			/* '-' */
%token <node> MUL			/* '*' */

%left SUB
%left MUL


%%

start:
	program			{ printf("accept\n"); }
;

program:
	sub_program		{
						$$ = createNonterminalNode("program");
						xmlDocSetRootElement(doc, $$);
						addChild($$, 1, $1);
					}
;

sub_program:
	PRO_BEGIN def_stmt_list SEM exec_stmt_list PRO_END		{
																$$ = createNonterminalNode("sub_program");
																addChild($$, 5, $1, $2, $3, $4, $5);
															}
;

def_stmt_list:
	def_stmt						{ $$ = createNonterminalNode("def_stmt_list"); addChild($$, 1, $1); }
	| def_stmt_list SEM def_stmt	{ $$ = createNonterminalNode("def_stmt_list"); addChild($$, 3, $1, $2, $3); }
;

def_stmt:
	var_def		{ $$ = createNonterminalNode("def_stmt"); addChild($$, 1, $1); }
	| func_def	{ $$ = createNonterminalNode("def_stmt"); addChild($$, 1, $1); }
;

var_def:
	INTEGER var	{
					$$ = createNonterminalNode("var_def");
					addChild($$, 2, $1, $2);
				}
;

var: id			{
					$$ = createNonterminalNode("var");
					addChild($$, 1, $1);
				}
;

id:
	letter		{ $$ = createNonterminalNode("id"); addChild($$, 1, $1); }
	| id LETTER	{ $$ = createNonterminalNode("id"); addChild($$, 2, $1, $2); }
	| id DIGIT	{ $$ = createNonterminalNode("id"); addChild($$, 2, $1, $2); }
;

letter:
	LETTER		{ $$ = createNonterminalNode("letter"); addChild($$, 1, $1); }
	;

func_def:
	INT_FUNC id LPAR param RPAR SEM func_body	{
													$$ = createNonterminalNode("func_def");
													addChild($$, 7, $1, $2, $3, $4, $5, $6, $7);
												}
;

param:
	var			{
					$$ = createNonterminalNode("param");
					addChild($$, 1, $1);
				}
;

func_body:
	PRO_BEGIN def_stmt_list SEM exec_stmt_list PRO_END	{
															$$ = createNonterminalNode("func_body");
															addChild($$, 5, $1, $2, $3, $4, $5);
														}
;

exec_stmt_list:
	exec_stmt						{ $$ = createNonterminalNode("exec_stmt_list"); addChild($$, 1, $1); }
	| exec_stmt_list SEM exec_stmt	{ $$ = createNonterminalNode("exec_stmt_list"); addChild($$, 3, $1, $2, $3); }
;

exec_stmt:
	read_stmt			{ $$ = createNonterminalNode("exec_stmt"); addChild($$, 1, $1); }
	| write_stmt		{ $$ = createNonterminalNode("exec_stmt"); addChild($$, 1, $1); }
	| assign_stmt		{ $$ = createNonterminalNode("exec_stmt"); addChild($$, 1, $1); }
	| condition_stmt	{ $$ = createNonterminalNode("exec_stmt"); addChild($$, 1, $1); }
;

read_stmt:
	READ LPAR var RPAR		{ $$ = createNonterminalNode("read_stmt"); addChild($$, 4, $1, $2, $3, $4); }
;

write_stmt:
	WRITE LPAR var RPAR		{ $$ = createNonterminalNode("write_stmt"); addChild($$, 4, $1, $2, $3, $4); }
;

assign_stmt:
	var ASSIGN calc_expr	{ $$ = createNonterminalNode("assign_stmt"); addChild($$, 3, $1, $2, $3); }
;

calc_expr:
	calc_expr SUB item	{ $$ = createNonterminalNode("calc_expr"); addChild($$, 3, $1, $2, $3); }
	| item				{ $$ = createNonterminalNode("calc_expr"); addChild($$, 1, $1); }
;

item:
	item MUL factor		{ $$ = createNonterminalNode("item"); addChild($$, 3, $1, $2, $3); }
	| factor			{ $$ = createNonterminalNode("item"); addChild($$, 1, $1); }
;

factor:
	var					{ $$ = createNonterminalNode("factor"); addChild($$, 1, $1); }
	| const				{ $$ = createNonterminalNode("factor"); addChild($$, 1, $1); }
	| func_call			{ $$ = createNonterminalNode("factor"); addChild($$, 1, $1); }
;

const:
	unsigned_int		{ $$ = createNonterminalNode("const"); addChild($$, 1, $1); }
;

unsigned_int:
	digit					{ $$ = createNonterminalNode("unsigned_int"); addChild($$, 1, $1); }
	| unsigned_int DIGIT	{ $$ = createNonterminalNode("unsigned_int"); addChild($$, 2, $1, $2); }
;

digit:
	DIGIT				{ $$ = createNonterminalNode("digit"); addChild($$, 1, $1); }
	;

func_call:
	id LPAR calc_expr RPAR	{
								$$ = createNonterminalNode("func_call");
								addChild($$, 3, $1, $2, $3);
							}
;

condition_stmt:
	IF condition_expr THEN exec_stmt ELSE exec_stmt	{
														$$ = createNonterminalNode("condition_stmt"); 
														addChild($$, 6, $1, $2, $3, $4, $5, $6);
													}
;

condition_expr:
	calc_expr rela_op calc_expr	{ $$ = createNonterminalNode("condition_expr"); addChild($$, 3, $1, $2, $3); }
;

rela_op:
	L		{ $$ = createNonterminalNode("rela_op"); addChild($$, 1, $1); }
	| LE	{ $$ = createNonterminalNode("rela_op"); addChild($$, 1, $1); }
	| G		{ $$ = createNonterminalNode("rela_op"); addChild($$, 1, $1); }
	| GE	{ $$ = createNonterminalNode("rela_op"); addChild($$, 1, $1); }
	| E		{ $$ = createNonterminalNode("rela_op"); addChild($$, 1, $1); }
	| NE	{ $$ = createNonterminalNode("rela_op"); addChild($$, 1, $1); }
;


%%

void yyerror(char *err)
{
	printf("yacc error: %s\n", err);
	printf("line: %d, before \"%s\"\n", yylineno, yytext);
}

