%{

#include <stdio.h>
#include <stdlib.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

int yylex(void);
void yyerror(char *err);

xmlNodePtr createNonterminalNode(char* nodeText);
void addChild(xmlNodePtr parent, int num, ...);

extern int		yylineno;
extern char		*yytext;
extern xmlDocPtr	doc;

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
			$$ = createNonterminalNode("program");
			addChild($$, 1, $1);
			xmlDocSetRootElement(doc, $$);
		}
	;

declaration_list:
	declaration_list declaration
		{
			$$ = createNonterminalNode("declaration_list");
			addChild($$, 2, $1, $2);
		}
	| declaration
		{
			$$ = createNonterminalNode("declaration_list");
			addChild($$, 1, $1);
		}
	;
	
declaration:
	var_declaration
		{
			$$ = createNonterminalNode("declaration");
			addChild($$, 1, $1);
		}
	| fun_declaration
		{
			$$ = createNonterminalNode("declaration");
			addChild($$, 1, $1);
		}
	;
	
var_declaration:
	type_specifier var_decl_list ';'
		{
			$$ = createNonterminalNode("var_declaration");
			addChild($$, 3, $1, $2, $3);
		}
	;

var_decl_list:
	var_decl_list ',' var_decl_id
		{
			$$ = createNonterminalNode("var_decl_list");
			addChild($$, 3, $1, $2, $3);
		}
	| var_decl_id
		{
			$$ = createNonterminalNode("var_decl_list");
			addChild($$, 1, $1);
		}
	;

var_decl_id:
	ID	{
			$$ = createNonterminalNode("var_decl_id");
			addChild($$, 1, $1);
		}
	| ID '[' NUM ']'
		{
			$$ = createNonterminalNode("var_decl_id");
			addChild($$, 4, $1, $2, $3, $4);
		}
	;
	
type_specifier:
	INT	{
			$$ = createNonterminalNode("type_specifer");
			addChild($$, 1, $1);
		}
	| VOID	{
			$$ = createNonterminalNode("type_specifer");
			addChild($$, 1, $1);
		}
	| BOOL	{
			$$ = createNonterminalNode("type_specifer");
			addChild($$, 1, $1);
		}
	;

fun_declaration:
	type_specifier ID '(' params ')' statement
		{
			$$ = createNonterminalNode("fun_declaration");
			addChild($$, 6, $1, $2, $3, $4, $5, $6);
		}
	;
	
params:
	param_list
		{
			$$ = createNonterminalNode("params");
			addChild($$, 1, $1);
		}
	| /* empty */
		{
			$$ = createNonterminalNode("params");
		}
	;

param_list:
	param_list ',' param_type_list
		{
			$$ = createNonterminalNode("param_list");
			addChild($$, 3, $1, $2, $3);
		}
	| param_type_list
		{
			$$ = createNonterminalNode("param_list");
			addChild($$, 1, $1);
		}
	;
	
param_type_list:
	type_specifier param_id
		{
			$$ = createNonterminalNode("param_type_list");
			addChild($$, 2, $1, $2);
		}
	;
	
param_id:
	ID	{
			$$ = createNonterminalNode("param_id");
			addChild($$, 1, $1);
		}
	| ID '[' ']'
		{
			$$ = createNonterminalNode("param_id");
			addChild($$, 3, $1, $2, $3);
		}
	;
	
compound_stmt:
	'{' local_declarations statement_list '}'
		{
			$$ = createNonterminalNode("compound_stmt");
			addChild($$, 4, $1, $2, $3, $4);
		}
	;
	
local_declarations:
	local_declarations var_declaration
		{
			$$ = createNonterminalNode("local_declaration");
			addChild($$, 2, $1, $2);
		}
	| /* empty */
		{
			$$ = createNonterminalNode("local_declaration");
		}
	;
	
statement_list:
	statement_list statement
		{
			$$ = createNonterminalNode("statement_list");
			addChild($$, 2, $1, $2);
		}
	| /* empty */
		{
			$$ = createNonterminalNode("statement_list");
		}
	;
	
statement:
	expression_stmt
		{
			$$ = createNonterminalNode("statement");
			addChild($$, 1, $1);
		}
	| compound_stmt
		{
			$$ = createNonterminalNode("statement");
			addChild($$, 1, $1);
		}
	| selection_stmt
		{
			$$ = createNonterminalNode("statement");
			addChild($$, 1, $1);
		}
	| iteration_stmt
		{
			$$ = createNonterminalNode("statement");
			addChild($$, 1, $1);
		}
	| return_stmt
		{
			$$ = createNonterminalNode("statement");
			addChild($$, 1, $1);
		}
	| break_stmt
		{
			$$ = createNonterminalNode("statement");
			addChild($$, 1, $1);
		}
	;
	
expression_stmt:
	expression ';'
		{
			$$ = createNonterminalNode("expression_stmt");
			addChild($$, 2, $1, $2);
		}
	| ';'	{
			$$ = createNonterminalNode("expression_stmt");
			addChild($$, 1, $1);
		}
	;
	
selection_stmt:
	IF '(' expression ')' statement %prec IFX
		{
			$$ = createNonterminalNode("selection_stmt");
			addChild($$, 5, $1, $2, $3, $4, $5);
		}
	| IF '(' expression ')' statement ELSE statement
		{
			$$ = createNonterminalNode("selection_stmt");
			addChild($$, 7, $1, $2, $3, $4, $5, $6, $7);
		}
	;
	
iteration_stmt:
	WHILE '(' expression ')' statement
		{
			$$ = createNonterminalNode("iteration_stmt");
			addChild($$, 5, $1, $2, $3, $4, $5);
		}
	;
	
return_stmt:
	RETURN ';'
		{
			$$ = createNonterminalNode("return_stmt");
			addChild($$, 2, $1, $2);
		}
	| RETURN expression ';'
		{
			$$ = createNonterminalNode("return_stmt");
			addChild($$, 3, $1, $2, $3);
		}
	;
	
break_stmt:
	BREAK ';'
		{
			$$ = createNonterminalNode("break_stmt");
			addChild($$, 2, $1, $2);
		}
	;
	
expression:
	var '=' expression
		{
			$$ = createNonterminalNode("expression");
			addChild($$, 3, $1, $2, $3);
		}
	| var ADD_ASSIGN expression
		{
			$$ = createNonterminalNode("expression");
			addChild($$, 3, $1, $2, $3);
		}
	| var SUB_ASSIGN expression
		{
			$$ = createNonterminalNode("expression");
			addChild($$, 3, $1, $2, $3);
		}
	| simple_expression
		{
			$$ = createNonterminalNode("expression");
			addChild($$, 1, $1);
		}
	;

var:
	ID	{
			$$ = createNonterminalNode("var");
			addChild($$, 1, $1);
		}
	| ID '[' expression ']'
		{
			$$ = createNonterminalNode("var");
			addChild($$, 4, $1, $2, $3, $4);
		}
	;

simple_expression:
	simple_expression '|' or_expression
		{
			$$ = createNonterminalNode("simple_expression");
			addChild($$, 3, $1, $2, $3);
		}
	| or_expression
		{
			$$ = createNonterminalNode("simple_expression");
			addChild($$, 1, $1);
		}
	;

or_expression:
	or_expression '&' unary_rel_expression
		{
			$$ = createNonterminalNode("or_expression");
			addChild($$, 3, $1, $2, $3);
		}
	| unary_rel_expression
		{
			$$ = createNonterminalNode("or_expression");
			addChild($$, 1, $1);
		}
	;

unary_rel_expression:
	'!' unary_expression
		{
			$$ = createNonterminalNode("unary_rel_expression");
			addChild($$, 2, $1, $2);
		}
	| rel_expression
		{
			$$ = createNonterminalNode("unary_rel_expression");
			addChild($$, 1, $1);
		}
	;

rel_expression:
	add_expression relop add_expression
		{
			$$ = createNonterminalNode("rel_expression");
			addChild($$, 3, $1, $2, $3);
		}
	| add_expression
		{
			$$ = createNonterminalNode("rel_expression");
			addChild($$, 1, $1);
		}
	;

relop:
	RELOP_LE
		{
			$$ = createNonterminalNode("relop");
			addChild($$, 1, $1);
		}
	| '<'	{
			$$ = createNonterminalNode("relop");
			addChild($$, 1, $1);
		}
	| '>'	{
			$$ = createNonterminalNode("relop");
			addChild($$, 1, $1);
		}
	| RELOP_GE
		{
			$$ = createNonterminalNode("relop");
			addChild($$, 1, $1);
		}
	| RELOP_E
		{
			$$ = createNonterminalNode("relop");
			addChild($$, 1, $1);
		}
	| RELOP_NE
		{
			$$ = createNonterminalNode("relop");
			addChild($$, 1, $1);
		}
	;

add_expression:
	add_expression addop term
		{
			$$ = createNonterminalNode("add_expression");
			addChild($$, 3, $1, $2, $3);
		}
	| term
		{
			$$ = createNonterminalNode("add_expression");
			addChild($$, 1, $1);
		}
	;

addop:
	'+'	{
			$$ = createNonterminalNode("addop");
			addChild($$, 1, $1);
		}
	| '-'	{
			$$ = createNonterminalNode("addop");
			addChild($$, 1, $1);
		}
	;

term:
	term mulop unary_expression
		{
			$$ = createNonterminalNode("term");
			addChild($$, 2, $1, $2);
		}
	| unary_expression
		{
			$$ = createNonterminalNode("term");
			addChild($$, 1, $1);
		}
	;

mulop:
	'*'	{
			$$ = createNonterminalNode("mulop");
			addChild($$, 1, $1);
		}
	| '/'	{
			$$ = createNonterminalNode("mulop");
			addChild($$, 1, $1);
		}
	| '%'	{
			$$ = createNonterminalNode("mulop");
			addChild($$, 1, $1);
		}
	;

unary_expression:
	'-' unary_expression
		{
			$$ = createNonterminalNode("unary_expression");
			addChild($$, 2, $1, $2);
		}
	| factor
		{
			$$ = createNonterminalNode("unary_expression");
			addChild($$, 1, $1);
		}
	;

factor:
	'(' expression ')'
		{
			$$ = createNonterminalNode("factor");
			addChild($$, 3, $1, $2, $3);
		}
	| var	{
			$$ = createNonterminalNode("factor");
			addChild($$, 1, $1);
		}
	| call	{
			$$ = createNonterminalNode("factor");
			addChild($$, 1, $1);
		}
	| constant
		{
			$$ = createNonterminalNode("factor");
			addChild($$, 1, $1);
		}
	;

constant:
	NUM	{
			$$ = createNonterminalNode("constant");
			addChild($$, 1, $1);
		}
	| _TRUE
		{
			$$ = createNonterminalNode("constant");
			addChild($$, 1, $1);
		}
	| _FALSE
		{
			$$ = createNonterminalNode("constant");
			addChild($$, 1, $1);
		}
	;

call:
	ID '(' args ')'
		{
			$$ = createNonterminalNode("call");
			addChild($$, 4, $1, $2, $3, $4);
		}
	;

args:
	arg_list
		{
			$$ = createNonterminalNode("args");
			addChild($$, 1, $1);
		}
	| /* empty */
		{
			$$ = createNonterminalNode("args");
		}
	;

arg_list:
	arg_list ',' expression
		{
			$$ = createNonterminalNode("arg_list");
			addChild($$, 3, $1, $2, $3);
		}
	| expression
		{
			$$ = createNonterminalNode("arg_list");
			addChild($$, 1, $1);
		}
	;

%%

void yyerror(char *err)
{
	printf("yacc error: %s\n", err);
	printf("line: %d, before \"%s\"\n", yylineno, yytext);
	exit(1);
}


