%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "tac.h"

int yylex(void);
void yyerror(char *err);

ENODE*	mkenode(TAC *code, SYMB* res);
TAC*    mktac(int op, SYMB* a, SYMB* b, SYMB* c);
SYMB*	mktmp();
SYMB*	mklabel();
ENODE*	do_bin(int op, ENODE* expr1, ENODE* expr2);
ENODE*	do_uminus(ENODE* expr);
ENODE*	do_call(SYMB *func, ENODE *arg_list);
TAC*	do_assign(SYMB* var, ENODE* expr);
TAC*    do_if(ENODE* expr, TAC* stmt);
TAC*    do_if_else(ENODE* expr, TAC* stmt1, TAC* stmt2);
TAC*	do_while(ENODE* expr, TAC* stmt);
TAC*	do_func(TAC* func_begin, TAC* param_list, TAC* stmt);
TAC*	do_func_begin(SYMB* func);
TAC*	do_return(ENODE *expr);
TAC*    declare_var(SYMB* var, int type);
TAC*	declare_param(SYMB *param);

TAC*	join_tac(TAC* t1, TAC* t2);
ENODE*	join_expr(ENODE* e1, ENODE* e2);

void	error(const char *fmt, ...);

extern int yylineno;
extern char *yytext;

%}

%union
{
	SYMB	*symb;
	TAC	*tac;
	ENODE	*enode;
}


%type <tac>	program
%type <tac>	func_list
%type <tac>	func
%type <tac>	func_begin
%type <tac>	param_list
%type <tac>	param
%type <tac>	param_item
%type <tac>	stmt
%type <tac>	stmt_list
%type <enode>	arg_list
%type <enode>	expr_list
%type <symb>    variable
%type <tac>	var_list
%type <tac>	decl
%type <tac>	decl_list
%type <tac>	assign_stmt
%type <tac>	if_stmt
%type <tac>	while_stmt
%type <tac>	return_stmt
%type <tac>	call_stmt
%type <tac>	block
%type <enode>	expr
%type <enode>   rela_g_expr
%type <enode>   rela_ge_expr
%type <enode>   rela_l_expr
%type <enode>   rela_le_expr
%type <enode>   rela_e_expr
%type <enode>   rela_ne_expr
%type <enode>	call_expr


%token		INT
%token		IF
%token		ELSE
%token		WHILE
%token		RETURN
%token <symb>	IDENTIFIER
%token <symb>	NUMBER
%token		GREATER_EQUAL
%token		LESS_EQUAL
%token		NOT_EQUAL
%token		EQUAL

%left  '>' GREATER_EQUAL '<' LESS_EQUAL
%left  EQUAL NOT_EQUAL
%left  '+' '-'
%left  '*' '/'
%right UMINUS

%nonassoc IFX
%nonassoc ELSE

%%

program		:	decl_list func_list
			{
				printf("acc\n");
				
				program_tac = join_tac( $1, $2 );
				
				//print_symbs();
			}
		;

func_list	:	func
		|	func_list func
			{
			        $$ = join_tac( $1, $2 );
			}
		;
		
func		:	func_begin param_list ')' stmt
			{
				$$ = do_func( $1, $2, $4 );

				/* switch to the global scope */
				current_symbtab = symbtabs[GLOBAL_SCOPE];
			}
		;
		
func_begin	:	INT IDENTIFIER '('
			{
				$$ = do_func_begin( $2 );
				
				/* switch to the local scope */
				if (next_local_scope < MAX_SCOPE)
					current_symbtab = symbtabs[next_local_scope++];
				else
					error("<error> symbtabs out of bound!\n");
			}
		;

param_list	:	param
		|	param_list ',' param
			{
				$$ = join_tac( $1, $3 );
			}
		;

param		:	INT param_item
			{
				$$ = $2;
			}
		|	/* empty */
			{
				$$ = NULL;
			}
		;

param_item	:	variable
			{
				$$ = declare_var( $1 , TAC_PARAM  );
			}
		;
		
stmt		:	assign_stmt
		|	if_stmt
		|	while_stmt
		|	return_stmt
		|	call_stmt
		|	block
		;
		
stmt_list	:	stmt
		|	stmt_list stmt
			{
                                $$ = join_tac( $1, $2 );
			}
		;
		
arg_list	:	expr_list
		|	/* empty */
			{
				$$ = NULL;
			}
		;
		
expr_list	:	expr
		|	expr_list ',' expr
			{
				$$ = join_expr( $1, $3 );
			}
		;

variable	:	IDENTIFIER
		;
			
var_list	:	variable
			{
				$$ = declare_var( $1 , TAC_VAR_DECL );
			}
		|	var_list ',' variable
			{
			        $$ = join_tac( $1, declare_var( $3 , TAC_VAR_DECL ));
			}
		;
		
decl		:	INT var_list ';'
			{
			        $$ = $2;
			}
		;

decl_list	:	decl_list decl
			{
			        $$ = join_tac( $1, $2 );
			}
		|	/* empty */
			{
				$$ = NULL;
			}
		;
		
assign_stmt	:	variable '=' expr ';'
			{
				$$ = do_assign( $1, $3 );
			}
		;
		
				
if_stmt		:	IF '(' expr ')' stmt %prec IFX
			{
			        $$ = do_if( $3, $5 );
			}
		|	IF '(' expr ')' stmt ELSE stmt
			{
			        $$ = do_if_else( $3, $5, $7 );
			}
		;
		
while_stmt	:	WHILE '(' expr ')' stmt
			{
				$$ = do_while( $3, $5 );
			}
		;
		
return_stmt	:	RETURN expr ';'
			{
				$$ = do_return( $2 );
			}
		;
		
call_stmt	:	call_expr ';'
			{
				$$ = $1->code;
			}
		;
		
block		:	'{' decl_list stmt_list '}'
			{
			        $$ = join_tac( $2, $3 );
			}
		;
		
expr		:	expr '+' expr
			{
				$$ = do_bin( TAC_ADD, $1, $3 );
			}
		|	expr '-' expr
			{
				$$ = do_bin( TAC_SUB, $1, $3 );
			}
		|	expr '*' expr
			{
				$$ = do_bin( TAC_MUL, $1, $3 );
			}
		|	expr '/' expr
			{
				$$ = do_bin( TAC_DIV, $1, $3 );
			}
		|	'(' expr ')'
			{
				$$ = $2;
			}
		|	variable
			{
				if (!lookup( current_symbtab, $1->TEXT ) &&
					!lookup( symbtabs[GLOBAL_SCOPE], $1->TEXT ))
				{
					error("<error> line: %d, variable \"%s\" undeclared!\n",
						yylineno, $1->TEXT);
				}
				$$ = mkenode( NULL, $1 );
			}
		|	NUMBER
			{
				$$ = mkenode( NULL, $1 );
			}
		|	'-' expr  %prec UMINUS
			{
				$$ = do_uminus( $2 );
			}

		|	rela_g_expr
		|	rela_ge_expr
		|	rela_l_expr
		|	rela_le_expr
		|	rela_e_expr
		|	rela_ne_expr
		|	call_expr
		;
		
rela_g_expr     :       expr '>' expr
                        {
				$$ = do_bin( TAC_GREATER, $1, $3 );
                        }
                ;

rela_ge_expr    :       expr GREATER_EQUAL expr
                        {
				$$ = do_bin( TAC_GREATER_EQUAL, $1, $3 );
                        }
                ;

rela_l_expr     :       expr '<' expr
                        {
				$$ = do_bin( TAC_LESS, $1, $3 );
                        }
                ;

rela_le_expr    :       expr LESS_EQUAL expr
                        {
				$$ = do_bin( TAC_LESS_EQUAL, $1, $3 );
                        }
                ;

rela_e_expr     :       expr EQUAL expr
                        {
				$$ = do_bin( TAC_EQUAL, $1, $3 );
                        }
                ;

rela_ne_expr    :       expr NOT_EQUAL expr
                        {
				$$ = do_bin( TAC_NOT_EQUAL, $1, $3 );
                        }
                ;
                
call_expr	:	IDENTIFIER '(' arg_list ')'
			{
				$$ = do_call( $1, $3 );
			}
		;
		
		
%%



ENODE* mkenode(TAC *code, SYMB *res)
{
	ENODE *enode;
	
	enode = (ENODE*) malloc(sizeof(ENODE));
	enode->code = code;
	enode->res = res;
	
	return enode;
}


TAC* mktac(int op, SYMB* a, SYMB* b, SYMB* c)
{
	TAC* tac;
	
	tac = (TAC*) malloc(sizeof(TAC));
	tac->prev = tac->next = NULL;
	tac->op = op;
	tac->VA = a;
	tac->VB = b;
	tac->VC = c;
	
	return tac;
}


SYMB* mktmp()
{
	SYMB *s;
	char name[4];
	
	sprintf(name, "T%d", next_temp++);
	
	s = get_symb(name);
	s->type = T_VAR;
	
	insert(s);
	
	return s;
}


SYMB* mklabel()
{
	SYMB *s;
	
	s = (SYMB*) malloc(sizeof(SYMB));
	s->type = T_LABEL;
	s->VAL  = next_label++;
	
	insert_list(s);

	return s;
}


ENODE* do_bin(int op, ENODE* expr1, ENODE* expr2)
{
	ENODE*	e;
	TAC*	code;
	TAC*    tmpdecl; /* declare `tmpvar` */
	TAC*    tmp;
	SYMB*	tmpvar;

	tmpvar  = mktmp();
	tmpdecl = mktac(TAC_VAR_DECL, tmpvar, NULL, NULL);
	
        code  = mktac(op, tmpvar, expr1->res, expr2->res);
        
	tmp  = join_tac(expr1->code, expr2->code);
	tmp  = join_tac(tmp, tmpdecl); 
	code = join_tac(tmp, code);
	
	free(expr1);
	free(expr2);
	
	e = mkenode(code, tmpvar);

	return e;
}


ENODE* do_uminus(ENODE* expr)
{
	ENODE*	e;
	TAC*	code;
	TAC*    tmpdecl; /* declare `tmpvar` */
	TAC*	tmp;
	SYMB*	tmpvar;

	tmpvar  = mktmp();
	tmpdecl = mktac(TAC_VAR_DECL, tmpvar, NULL, NULL);

        code = mktac(TAC_UMINUS, tmpvar, expr->res, NULL);
	
	tmp  = join_tac(expr->code, tmpdecl);
	code = join_tac(tmp, code);
	
	free(expr);
	
	e = mkenode(code, tmpvar);

	return e;	
}

ENODE* do_call(SYMB *func, ENODE *arg_list)
{
	ENODE *e;
	TAC   *arg;
	TAC   *tac;
	TAC   *call;
	TAC   *retdecl; /* declare `retcal` */
	TAC   *tmp;
	SYMB  *retval;
	
	if (!lookup(symbtabs[GLOBAL_SCOPE], func->TEXT))
	{
		error("<error> line: %d, function \"%s\" undeclared!",
			yylineno, func->TEXT);
	}
	
	// 遍历参数表达式链表, 生成<参数传递语句链>
	// 对于表达式链 E1->E2-> ... ->En,
	// 第 1 轮迭代生成 {E1->code, arg E1->res}, 第 2 轮生成 {E2->code, arg E2->res},
	// 并将 {E1->code, arg E1->res} 附加到其末尾, 形成一条新链:
	// {E2->code, arg E2->res} -> {E1->code, arg E1->res}; 最终将表达式链转换为:
	// {En->code, arg En->res} -> ... -> {E2->code, arg E2->res} -> {E1->code, arg E1->res}.
	// 由此生成的<参数传递链>符合 C/C++ 中"从右向左"的传参顺序.
	tac = NULL;
	e = arg_list;
	while (e != NULL)
	{
		arg = mktac(TAC_ARG, e->res, NULL, NULL);
		arg = join_tac(arg, tac);
		tac = join_tac(e->code, arg);
		e = e->next;
		free(e);
	}
	
	arg = tac; // 将<参数传递语句链>保存到 arg
	retval  = mktmp(); // 返回值赋给临时变量 retval
	retdecl = mktac(TAC_VAR_DECL, retval, NULL, NULL);
	call = mktac(TAC_CALL, retval, func, NULL); // 生成<call语句>: T = call foo
	tmp = join_tac(arg, retdecl);
	call = join_tac(tmp, call); // 合并<参数传递语句链>和<call语句>
	
	// 表达式的值: retval
	// 与表达式的值关联的三地址码: call
	e = mkenode(call, retval);
	
	return e;
}


TAC* do_assign(SYMB* var, ENODE* expr)
{
	TAC* tac;
	TAC* code;

	if (!lookup(current_symbtab, var->TEXT) && 
		!lookup(symbtabs[GLOBAL_SCOPE], var->TEXT))
	{
		error("<error> line %d, variable \"%s\" undeclared!\n",
			yylineno, var->TEXT);
		return NULL;
	}
	
	tac = mktac(TAC_ASSIGN, var, expr->res, NULL);
	
	free(expr);
	
	return join_tac(expr->code, tac);
}


TAC* do_if(ENODE* expr, TAC* stmt)
/**
 *          ifnz expr goto true-branch      ( tac_true  )
 *          goto false-branch               ( tac_false )
 *      true-branch:
 *          stmt
 *      false-branch:
 *      ...
 */
{
        TAC *tac;
        TAC *tac_true;
        TAC *tac_false;
        TAC *true_branch;
        TAC *false_branch;
        
        true_branch  = mktac(TAC_LABEL, mklabel(), NULL, NULL);
        false_branch = mktac(TAC_LABEL, mklabel(), NULL, NULL);
        
        tac_true  = mktac(TAC_IFNZ, expr->res, true_branch->VA,  NULL);
        tac_false = mktac(TAC_GOTO, false_branch->VA, NULL, NULL);
        
        tac = join_tac(expr->code, tac_true);
        tac = join_tac(tac, tac_false);
        tac = join_tac(tac, true_branch);
        tac = join_tac(tac, stmt);
        tac = join_tac(tac, false_branch);
        
        free(expr);
        
        return tac;
}


TAC* do_if_else(ENODE* expr, TAC* stmt1, TAC* stmt2)
/**
 *          ifnz expr goto true_branch  ( tac_true  )
 *          goto false_branch           ( tac_false )
 *      true_branch:
 *          stmt1
 *          goto brk_branch
 *      false_branch:
 *          stmt2
 *      brk_branch:
 *          ...
 *
 */
{
        TAC *tac;
        TAC *tac_true;
        TAC *tac_false;
        TAC *tac_brk;
        TAC *true_branch;
        TAC *false_branch;
        TAC *brk_branch;
        
        true_branch  = mktac(TAC_LABEL, mklabel(), NULL, NULL);
        false_branch = mktac(TAC_LABEL, mklabel(), NULL, NULL);
        brk_branch   = mktac(TAC_LABEL, mklabel(), NULL, NULL);
        
        tac_true  = mktac(TAC_IFNZ, expr->res, true_branch->VA,  NULL);
        tac_false = mktac(TAC_GOTO, false_branch->VA, NULL, NULL);
        tac_brk   = mktac(TAC_GOTO, brk_branch->VA,   NULL, NULL);
        
        tac = join_tac(expr->code, tac_true);
        tac = join_tac(tac, tac_false);
        tac = join_tac(tac, true_branch);
        tac = join_tac(tac, stmt1);
        tac = join_tac(tac, tac_brk);
        tac = join_tac(tac, false_branch);
        tac = join_tac(tac, stmt2);
        tac = join_tac(tac, brk_branch);
        
        free(expr);
        
        return tac;
}


TAC* do_while(ENODE* expr, TAC* stmt)
/**
 *	test:
 *	    ifnz expr goto true_branch	( tac_true  )
 *	    goto false_branch		( tac_false )
 *	true_branch:
 *	    stmt
 *	    goto test			( tac_loop )
 *	false_branch:
 *
 */
{
	TAC *tac;
	TAC *test;
	TAC *tac_true;
	TAC *tac_false;
	TAC *true_branch;
	TAC *false_branch;
	TAC *tac_loop;
	
	test         = mktac(TAC_LABEL, mklabel(), NULL, NULL);
	true_branch  = mktac(TAC_LABEL, mklabel(), NULL, NULL);
        false_branch = mktac(TAC_LABEL, mklabel(), NULL, NULL);
        
	tac_true  = mktac(TAC_IFNZ, expr->res, true_branch->VA, NULL);
	tac_false = mktac(TAC_GOTO, false_branch->VA, NULL, NULL);
	tac_loop  = mktac(TAC_GOTO, test->VA,         NULL, NULL);
	
	tac = join_tac(test, expr->code);
	tac = join_tac(tac,  tac_true);
	tac = join_tac(tac,  tac_false);
	tac = join_tac(tac,  true_branch);
	tac = join_tac(tac,  stmt);
	tac = join_tac(tac,  tac_loop);
	tac = join_tac(tac,  false_branch);
	
	free(expr);
	
	return tac;
}


TAC* do_func(TAC* func_begin, TAC* param_list, TAC* stmt)
{
	TAC* tac;
	TAC* end;
	
	end = mktac(TAC_END_FUNC, NULL, NULL, NULL);
	tac = join_tac(func_begin, param_list);
	tac = join_tac(tac, stmt);
	tac = join_tac(tac, end);
	
	return tac;
}


TAC* do_func_begin(SYMB* func)
{
	TAC* tac;
	TAC* begin;

	func->type = T_FUNC;
	insert(func);

	tac   = mktac(TAC_FUNC,       func, NULL, NULL);
	begin = mktac(TAC_BEGIN_FUNC, NULL, NULL, NULL);
	
	return join_tac(tac, begin);
}


TAC* do_return(ENODE *expr)
{
	TAC* tac;
	
	tac = mktac(TAC_RETURN, expr->res, NULL, NULL);
	tac = join_tac(expr->code, tac);
	
	free(expr);
	
	return tac;
}


TAC* declare_var(SYMB* var, int type)
{
        if (lookup(current_symbtab, var->TEXT) ||
		lookup(symbtabs[GLOBAL_SCOPE], var->TEXT))
        {
                error("<error> line: %d, variable \"%s\" already declared!\n",
                	yylineno, var->TEXT);
                return NULL;
        }
        
	var->type = T_VAR;
        insert(var);
        
        return mktac(type, var, NULL, NULL);
}

/**
 *  @brief   Merge two linked lists of tac: attach `t2` to the tail of `t1`.
 *  @return  Head of the new linked list.
 */
TAC* join_tac(TAC* t1, TAC* t2)
{
	TAC* t;
	
	if (t1 == NULL)
	        return t2;
	
	t = t1;
	
	if (t != NULL)
	{
	        while (t->next != NULL)
		        t = t->next;

                if (t2 != NULL)
                        t2->prev = t;

        	t->next = t2;
	}
	
	return t1;
}


/**
 *  @brief   Merge two linked lists of expr: attach `e2` to the tail of `e1`.
 *  @return  Head of the new linked list.
 */
ENODE* join_expr(ENODE* e1, ENODE* e2)
{
	ENODE *e;
		
	if (e1 == NULL)
	        return e2;
	
	e = e1;
	
	if (e != NULL)
	{
	        while (e->next != NULL)
		        e = e->next;

                if (e2 != NULL)
                        e2->prev = e;

        	e->next = e2;
	}
	
	return e1;
}


void error(const char *fmt, ...)
{
	char s[64];
	va_list arg;
	
	va_start(arg, fmt);
	vsprintf(s, fmt, arg);
	va_end(arg);
	
	fprintf(stderr, "%s", s);
	exit(1);
}

void yyerror(char *err)
{
	fprintf(stderr, "yacc error: %s\n", err);
	fprintf(stderr, "line: %d, before \"%s\"\n", yylineno, yytext);
}


