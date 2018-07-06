%{

#include <stdio.h>
#include <stdlib.h>
#include "syntax.h"

int yylex(void);
void yyerror(char *err);

xmlNodePtr create_nonterminal_node(char* nodeText);
void add_children(xmlNodePtr parent, int num, ...);

extern int		yylineno;
extern char		*yytext;
extern xmlDocPtr	g_syntax_tree_doc;

%}

%union
{
	xmlNodePtr node;
};

/* 非终结符 */
%type <node> program
%type <node> declaration_list
%type <node> declaration
%type <node> var_declaration
%type <node> var_decl_list
%type <node> var_decl_id
%type <node> type_specifier
%type <node> fun_declaration
%type <node> params
%type <node> param_list
%type <node> param_type_list
%type <node> param_id
%type <node> compound_stmt
%type <node> local_declarations
%type <node> statement_list
%type <node> statement
%type <node> expression_stmt
%type <node> selection_stmt
%type <node> iteration_stmt
%type <node> return_stmt
%type <node> break_stmt
%type <node> expression
%type <node> var
%type <node> simple_expression
%type <node> or_expression
%type <node> unary_rel_expression
%type <node> rel_expression
%type <node> relop
%type <node> add_expression
%type <node> addop
%type <node> term
%type <node> mulop
%type <node> unary_expression
%type <node> factor
%type <node> constant
%type <node> call
%type <node> args
%type <node> arg_list


/* 终结符 */
%token <node> ID
%token <node> NUM
%token <node> INT
%token <node> VOID
%token <node> BOOL
%token <node> IF
%token <node> ELSE
%token <node> WHILE
%token <node> BREAK
%token <node> RETURN
%token <node> RELOP_E
%token <node> RELOP_NE
%token <node> RELOP_GE
%token <node> RELOP_LE
%token <node> _TRUE
%token <node> _FALSE
%token <node> ADD_ASSIGN
%token <node> SUB_ASSIGN

%token <node> ';'
%token <node> ','
%token <node> '('
%token <node> ')'
%token <node> '['
%token <node> ']'
%token <node> '{'
%token <node> '}'
%token <node> '+'
%token <node> '-'
%token <node> '*'
%token <node> '/'
%token <node> '%'
%token <node> '!'
%token <node> '|'
%token <node> '&'
%token <node> '='
%token <node> '<'
%token <node> '>'

%nonassoc IFX
%nonassoc ELSE


%%

program:
	declaration_list
		{
			printf("accept\n");
			$$ = create_nonterminal_node("program");
			add_children($$, 1, $1);
			xmlDocSetRootElement(g_syntax_tree_doc, $$);
		}
	;

declaration_list:
	declaration_list declaration
		{
			$$ = create_nonterminal_node("declaration_list");
			add_children($$, 2, $1, $2);
		}
	| declaration
		{
			$$ = create_nonterminal_node("declaration_list");
			add_children($$, 1, $1);
		}
	;
	
declaration:
	var_declaration
		{
			$$ = create_nonterminal_node("declaration");
			add_children($$, 1, $1);
		}
	| fun_declaration
		{
			$$ = create_nonterminal_node("declaration");
			add_children($$, 1, $1);
		}
	;
	
var_declaration:
	type_specifier var_decl_list ';'
		{
			$$ = create_nonterminal_node("var_declaration");
			add_children($$, 3, $1, $2, $3);
		}
	;

var_decl_list:
	var_decl_list ',' var_decl_id
		{
			$$ = create_nonterminal_node("var_decl_list");
			add_children($$, 3, $1, $2, $3);
		}
	| var_decl_id
		{
			$$ = create_nonterminal_node("var_decl_list");
			add_children($$, 1, $1);
		}
	;

var_decl_id:
	ID	{
			$$ = create_nonterminal_node("var_decl_id");
			add_children($$, 1, $1);
		}
	| ID '[' NUM ']'
		{
			$$ = create_nonterminal_node("var_decl_id");
			add_children($$, 4, $1, $2, $3, $4);
		}
	;
	
type_specifier:
	INT	{
			$$ = create_nonterminal_node("type_specifer");
			add_children($$, 1, $1);
		}
	| VOID	{
			$$ = create_nonterminal_node("type_specifer");
			add_children($$, 1, $1);
		}
	| BOOL	{
			$$ = create_nonterminal_node("type_specifer");
			add_children($$, 1, $1);
		}
	;

fun_declaration:
	type_specifier ID '(' params ')' statement
		{
			$$ = create_nonterminal_node("fun_declaration");
			add_children($$, 6, $1, $2, $3, $4, $5, $6);
		}
	;
	
params:
	param_list
		{
			$$ = create_nonterminal_node("params");
			add_children($$, 1, $1);
		}
	| /* empty */
		{
			$$ = create_nonterminal_node("params");
		}
	;

param_list:
	param_list ',' param_type_list
		{
			$$ = create_nonterminal_node("param_list");
			add_children($$, 3, $1, $2, $3);
		}
	| param_type_list
		{
			$$ = create_nonterminal_node("param_list");
			add_children($$, 1, $1);
		}
	;
	
param_type_list:
	type_specifier param_id
		{
			$$ = create_nonterminal_node("param_type_list");
			add_children($$, 2, $1, $2);
		}
	;
	
param_id:
	ID	{
			$$ = create_nonterminal_node("param_id");
			add_children($$, 1, $1);
		}
	| ID '[' ']'
		{
			$$ = create_nonterminal_node("param_id");
			add_children($$, 3, $1, $2, $3);
		}
	;
	
compound_stmt:
	'{' local_declarations statement_list '}'
		{
			$$ = create_nonterminal_node("compound_stmt");
			add_children($$, 4, $1, $2, $3, $4);
		}
	;
	
local_declarations:
	local_declarations var_declaration
		{
			$$ = create_nonterminal_node("local_declaration");
			add_children($$, 2, $1, $2);
		}
	| /* empty */
		{
			$$ = create_nonterminal_node("local_declaration");
		}
	;
	
statement_list:
	statement_list statement
		{
			$$ = create_nonterminal_node("statement_list");
			add_children($$, 2, $1, $2);
		}
	| /* empty */
		{
			$$ = create_nonterminal_node("statement_list");
		}
	;
	
statement:
	expression_stmt
		{
			$$ = create_nonterminal_node("statement");
			add_children($$, 1, $1);
		}
	| compound_stmt
		{
			$$ = create_nonterminal_node("statement");
			add_children($$, 1, $1);
		}
	| selection_stmt
		{
			$$ = create_nonterminal_node("statement");
			add_children($$, 1, $1);
		}
	| iteration_stmt
		{
			$$ = create_nonterminal_node("statement");
			add_children($$, 1, $1);
		}
	| return_stmt
		{
			$$ = create_nonterminal_node("statement");
			add_children($$, 1, $1);
		}
	| break_stmt
		{
			$$ = create_nonterminal_node("statement");
			add_children($$, 1, $1);
		}
	;
	
expression_stmt:
	expression ';'
		{
			$$ = create_nonterminal_node("expression_stmt");
			add_children($$, 2, $1, $2);
		}
	| ';'	{
			$$ = create_nonterminal_node("expression_stmt");
			add_children($$, 1, $1);
		}
	;
	
selection_stmt:
	IF '(' expression ')' statement %prec IFX
		{
			$$ = create_nonterminal_node("selection_stmt");
			add_children($$, 5, $1, $2, $3, $4, $5);
		}
	| IF '(' expression ')' statement ELSE statement
		{
			$$ = create_nonterminal_node("selection_stmt");
			add_children($$, 7, $1, $2, $3, $4, $5, $6, $7);
		}
	;
	
iteration_stmt:
	WHILE '(' expression ')' statement
		{
			$$ = create_nonterminal_node("iteration_stmt");
			add_children($$, 5, $1, $2, $3, $4, $5);
		}
	;
	
return_stmt:
	RETURN ';'
		{
			$$ = create_nonterminal_node("return_stmt");
			add_children($$, 2, $1, $2);
		}
	| RETURN expression ';'
		{
			$$ = create_nonterminal_node("return_stmt");
			add_children($$, 3, $1, $2, $3);
		}
	;
	
break_stmt:
	BREAK ';'
		{
			$$ = create_nonterminal_node("break_stmt");
			add_children($$, 2, $1, $2);
		}
	;
	
expression:
	var '=' expression
		{
			$$ = create_nonterminal_node("expression");
			add_children($$, 3, $1, $2, $3);
		}
	| var ADD_ASSIGN expression
		{
			$$ = create_nonterminal_node("expression");
			add_children($$, 3, $1, $2, $3);
		}
	| var SUB_ASSIGN expression
		{
			$$ = create_nonterminal_node("expression");
			add_children($$, 3, $1, $2, $3);
		}
	| simple_expression
		{
			$$ = create_nonterminal_node("expression");
			add_children($$, 1, $1);
		}
	;

var:
	ID	{
			$$ = create_nonterminal_node("var");
			add_children($$, 1, $1);
		}
	| ID '[' expression ']'
		{
			$$ = create_nonterminal_node("var");
			add_children($$, 4, $1, $2, $3, $4);
		}
	;

simple_expression:
	simple_expression '|' or_expression
		{
			$$ = create_nonterminal_node("simple_expression");
			add_children($$, 3, $1, $2, $3);
		}
	| or_expression
		{
			$$ = create_nonterminal_node("simple_expression");
			add_children($$, 1, $1);
		}
	;

or_expression:
	or_expression '&' unary_rel_expression
		{
			$$ = create_nonterminal_node("or_expression");
			add_children($$, 3, $1, $2, $3);
		}
	| unary_rel_expression
		{
			$$ = create_nonterminal_node("or_expression");
			add_children($$, 1, $1);
		}
	;

unary_rel_expression:
	'!' unary_expression
		{
			$$ = create_nonterminal_node("unary_rel_expression");
			add_children($$, 2, $1, $2);
		}
	| rel_expression
		{
			$$ = create_nonterminal_node("unary_rel_expression");
			add_children($$, 1, $1);
		}
	;

rel_expression:
	add_expression relop add_expression
		{
			$$ = create_nonterminal_node("rel_expression");
			add_children($$, 3, $1, $2, $3);
		}
	| add_expression
		{
			$$ = create_nonterminal_node("rel_expression");
			add_children($$, 1, $1);
		}
	;

relop:
	RELOP_LE
		{
			$$ = create_nonterminal_node("relop");
			add_children($$, 1, $1);
		}
	| '<'	{
			$$ = create_nonterminal_node("relop");
			add_children($$, 1, $1);
		}
	| '>'	{
			$$ = create_nonterminal_node("relop");
			add_children($$, 1, $1);
		}
	| RELOP_GE
		{
			$$ = create_nonterminal_node("relop");
			add_children($$, 1, $1);
		}
	| RELOP_E
		{
			$$ = create_nonterminal_node("relop");
			add_children($$, 1, $1);
		}
	| RELOP_NE
		{
			$$ = create_nonterminal_node("relop");
			add_children($$, 1, $1);
		}
	;

add_expression:
	add_expression addop term
		{
			$$ = create_nonterminal_node("add_expression");
			add_children($$, 3, $1, $2, $3);
		}
	| term
		{
			$$ = create_nonterminal_node("add_expression");
			add_children($$, 1, $1);
		}
	;

addop:
	'+'	{
			$$ = create_nonterminal_node("addop");
			add_children($$, 1, $1);
		}
	| '-'	{
			$$ = create_nonterminal_node("addop");
			add_children($$, 1, $1);
		}
	;

term:
	term mulop unary_expression
		{
			$$ = create_nonterminal_node("term");
			add_children($$, 2, $1, $2);
		}
	| unary_expression
		{
			$$ = create_nonterminal_node("term");
			add_children($$, 1, $1);
		}
	;

mulop:
	'*'	{
			$$ = create_nonterminal_node("mulop");
			add_children($$, 1, $1);
		}
	| '/'	{
			$$ = create_nonterminal_node("mulop");
			add_children($$, 1, $1);
		}
	| '%'	{
			$$ = create_nonterminal_node("mulop");
			add_children($$, 1, $1);
		}
	;

unary_expression:
	'-' unary_expression
		{
			$$ = create_nonterminal_node("unary_expression");
			add_children($$, 2, $1, $2);
		}
	| factor
		{
			$$ = create_nonterminal_node("unary_expression");
			add_children($$, 1, $1);
		}
	;

factor:
	'(' expression ')'
		{
			$$ = create_nonterminal_node("factor");
			add_children($$, 3, $1, $2, $3);
		}
	| var	{
			$$ = create_nonterminal_node("factor");
			add_children($$, 1, $1);
		}
	| call	{
			$$ = create_nonterminal_node("factor");
			add_children($$, 1, $1);
		}
	| constant
		{
			$$ = create_nonterminal_node("factor");
			add_children($$, 1, $1);
		}
	;

constant:
	NUM	{
			$$ = create_nonterminal_node("constant");
			add_children($$, 1, $1);
		}
	| _TRUE
		{
			$$ = create_nonterminal_node("constant");
			add_children($$, 1, $1);
		}
	| _FALSE
		{
			$$ = create_nonterminal_node("constant");
			add_children($$, 1, $1);
		}
	;

call:
	ID '(' args ')'
		{
			$$ = create_nonterminal_node("call");
			add_children($$, 4, $1, $2, $3, $4);
		}
	;

args:
	arg_list
		{
			$$ = create_nonterminal_node("args");
			add_children($$, 1, $1);
		}
	| /* empty */
		{
			$$ = create_nonterminal_node("args");
		}
	;

arg_list:
	arg_list ',' expression
		{
			$$ = create_nonterminal_node("arg_list");
			add_children($$, 3, $1, $2, $3);
		}
	| expression
		{
			$$ = create_nonterminal_node("arg_list");
			add_children($$, 1, $1);
		}
	;

%%

void yyerror(char *err)
{
	printf("yacc error: %s\n", err);
	printf("line: %d, before \"%s\"\n", yylineno, yytext);
	exit(1);
}


