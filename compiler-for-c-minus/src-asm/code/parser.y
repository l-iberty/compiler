%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asm.h"

int yylex(void);
void yyerror(char *err);

extern int yylineno;
extern char *yytext;

%}

%union
{
	SYMB	*symb;
}

%type <symb>	program
%type <symb>	function
%type <symb>	func_begin
%type <symb>	func_end
%type <symb>	function_list
%type <symb>    label_stmt
%type <symb>	decl_stmt
%type <symb>	decl_stmt_list
%type <symb>	call_stmt
%type <symb>    assign_stmt
%type <symb>    jz_stmt
%type <symb>    jnz_stmt
%type <symb>	jmp_stmt
%type <symb>    arg_stmt
%type <symb>	param_stmt
%type <symb>    return_stmt
%type <symb>	function_stmt
%type <symb>    expr
%type <symb>    rela_g_expr
%type <symb>    rela_ge_expr
%type <symb>    rela_l_expr
%type <symb>    rela_le_expr
%type <symb>    rela_e_expr
%type <symb>    rela_ne_expr
%type <symb>    stmt
%type <symb>    stmt_list

%token		GREATER
%token		GREATER_EQUAL
%token		LESS
%token		LESS_EQUAL
%token		EQUAL
%token		NOT_EQUAL
%token		FUNCTION
%token		BEGIN_FUNC
%token		END_FUNC
%token <symb>	NUM
%token		VAR_INT
%token		INT_PARAM
%token <symb>	VARIABLE
%token <symb>	LABEL
%token <symb>   LABEL_NAME
%token		IFZ
%token		IFNZ
%token		GOTO
%token		CALL
%token		ARG
%token		RETURN


%left GREATER GREATER_EQUAL LESS LESS_EQUAL
%left EQUAL NOT_EQUAL
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

program		:	decl_stmt_list function_list
			{
                                printf("accept!\n");
				//print_symbtabs();
			}
		;

function	:	func_begin  stmt_list  func_end
			{

			}
		;

func_begin	:	label_stmt
			function_stmt
			LABEL
			BEGIN_FUNC
			{
				begin_func( $2, $3 );
			}
		;

func_end	:	END_FUNC
			{
				end_func();
			}
		;
		
function_list	:	function_list function
		|	function
		;

		
label_stmt      :       LABEL
                        {
				do_label( $1 );
                        }
                ;

decl_stmt	:	VAR_INT VARIABLE
			{
				declare_var( $2 );
			}
		;

decl_stmt_list	:	decl_stmt_list decl_stmt
		|	{ /* empty */ }
		;

call_stmt	:	CALL LABEL_NAME
			{
				$$ = do_call( $2 );
			}
		;

assign_stmt	:	VARIABLE '=' expr
			{
				do_assign( $1, $3 );	
			}
		;

jz_stmt         :       IFZ expr GOTO LABEL_NAME
                        {
                        	do_jz( $2, $4 );
                        }
                ;

jnz_stmt        :       IFNZ expr GOTO LABEL_NAME
                        {
                        	do_jnz( $2, $4 );
                        }
                ;

jmp_stmt	:	GOTO LABEL_NAME
			{
				do_jmp( $2 );
			}
		;
                
arg_stmt        :       ARG expr
                        {
                        	do_arg( $2 );
                        }
                ;

param_stmt	:	INT_PARAM VARIABLE
			{
				declare_param( $2 );
			}
		;

return_stmt     :       RETURN expr
                        {
				do_return( $2 );
                        }
                ;

function_stmt	:	FUNCTION VARIABLE
			{
				$$ = $2;
			}
		;

expr            :       expr '+' expr
                        {
                        	$$ = do_add( $1, $3 );
                        }
                |       expr '-' expr
                        {
                        	$$ = do_sub( $1, $3 );
                        }
                |       expr '*' expr
                        {
                        	$$ = do_mul( $1, $3 );
                        }
                |       expr '/' expr
                        {
                        	$$ = do_div( $1, $3 );
                        }
		|	rela_g_expr
			{
			        $$ = $1;
			}
		|	rela_ge_expr
			{
				$$ = $1;
			}
		|	rela_l_expr
			{
			        $$ = $1;
			}
		|	rela_le_expr
			{
			        $$ = $1;
			}
		|	rela_e_expr
			{
			        $$ = $1;
			}
		|	rela_ne_expr
			{
			        $$ = $1;
			}
                |       '-' expr %prec UMINUS
                        {
                        	$$ = do_uminus( $2 );
                        }
                |       call_stmt
                        {
				$$ = $1;
                        }
                |       VARIABLE
                        {
				$$ = $1;
                        }
                |       NUM
                        {
				$$ = $1;
                        }
                ;

rela_g_expr	:	expr GREATER expr
			{
				$$ = do_rela( "ja", $1, $3 );
			}
		;

rela_ge_expr	:	expr GREATER_EQUAL expr
			{
                                $$ = do_rela( "jae", $1, $3 );
			}
		;

rela_l_expr	:	expr LESS expr
			{
			        $$ = do_rela( "jl", $1, $3 );
			}
		;

rela_le_expr	:	expr LESS_EQUAL expr
			{
			        $$ = do_rela( "jle", $1, $3 );
			}
		;

rela_e_expr	:	expr EQUAL expr
			{
			        $$ = do_rela( "je", $1, $3 );
			}
		;

rela_ne_expr	:	expr NOT_EQUAL expr
			{
			        $$ = do_rela( "jne", $1, $3 );
			}
		;


stmt            :       decl_stmt
                |       label_stmt
                |       call_stmt
                |       assign_stmt
                |       jz_stmt
                |       jnz_stmt
		|	jmp_stmt
                |       arg_stmt
		|	param_stmt
                |       return_stmt
		|	function_stmt
                ;

stmt_list       :       stmt_list stmt
                |       stmt
                ;


%%

void begin_func(SYMB *func, SYMB *label)
{
	char label_name[32];
	char *p;

	/* Eliminate ':' from label name */
	strcpy(label_name, label->name);
	p = label_name;
	while (*p)
	{
		if (*p == ':')
		{
			*p = '\0';
			break;
		}
		p++;
	}
	
	init_strlist();

	do_global(func, EXPORT_FUNC);
	do_label(label);
	
	insert_str("\tpush ebp\n");
	insert_str( "\tmov ebp, esp\n");

	/* allocate memory for local variables, but memory size is unknown now,
           which is calculated dynamically. */
           
	pnode = insert_str( "\tsub esp, 0x00000000\n");
	
	/* switch to local scope */
	
	if (next_local_scope < SCOPE_MAX)
	{
		current_symbtab = symbtabs[next_local_scope++];
	}
	else
	{
		printf("symbtabs out of bound\n");
	}

	param_off = PARAM_OFFSET_BEGIN;
}

void end_func()
{
	int current_local_scope = next_local_scope - 1;

	insert_str("endfunc%d:\n", current_local_scope);
	insert_str( "\tmov esp, ebp\n");
	insert_str( "\tpop ebp\n");
	insert_str( "\tret\n");
	
	sprintf(pnode->str, "\tsub esp, 0x%.8X\n", local_mem_size);
	
	print_strlist();
	free_strlist();

        local_mem_size = MIN_LOCAL_MEM_SIZE;
	local_var_off = 0; /* leave local scope */
	param_off = PARAM_OFFSET_BEGIN;
}

void declare_var(SYMB *var)
{
	if (current_symbtab != symbtabs[GLOBAL_SCOPE])
	{
		/* rewrite OFFSET only when we're in the local scope */
		
		local_var_off -= VAR_OFFSET;
		var->OFFSET = local_var_off;
	}
	else
	{
		/* export global variable */
		
		do_global(var, EXPORT_DATA);
		fprintf(asm_file, "%s  dd  0\n", var->name);
	}

	insert(var);
}

void declare_param(SYMB *param)
{
	if (current_symbtab != symbtabs[GLOBAL_SCOPE])
	{
		/* rewrite OFFSET only when we're in the local scope */
		param_off += VAR_OFFSET;
		param->OFFSET = param_off;
	}

	insert(param);
}

void do_assign(SYMB *left, SYMB *right)
{
	/* Data is NOT ready for assignment when `right->type` equals either
	   T_NUM or T_VAR, so we need to move data to EAX. */

	to_eax(right);

	/* Data has been written to EAX, ready for assigment. */
	
	if (left->OFFSET != 0)
	{
		/* local variable or parameter */

		insert_str( "\tmov [ebp + 0x%.8X], eax\n", left->OFFSET);
		
		if (left->OFFSET < 0)
		{
		        /* local variable */
		        local_mem_size += VAR_OFFSET;
		}
	}
	else
	{
		/* global variable */

		insert_str( "\tmov [%s], eax\n", left->name);
	}
}

void do_return(SYMB *expr)
{
	int current_local_scope = next_local_scope - 1;

	/* move return value into EAX */
	to_eax(expr);

	/* jump to the end of function */
	insert_str("\tjmp endfunc%d\n", current_local_scope);
}

void do_jz(SYMB *expr, SYMB *label)
{
	to_eax(expr);
	insert_str( "\tcmp eax, 0\n");
	insert_str( "\tjz %s\n", label->name);
}

void do_jnz(SYMB *expr, SYMB *label)
{
	to_eax(expr);
	insert_str( "\tcmp eax, 0\n");
	insert_str( "\tjnz %s\n", label->name);
}

void do_jmp(SYMB *label)
{
	insert_str( "\tjmp %s\n", label->name);
}

void do_label(SYMB *label)
{
	if (!flag_code_seg)
	{
		fprintf(asm_file, "\n[section .text]\n"); /* code segment begins */
		flag_code_seg = TRUE;
	}

	if (strlist != NULL) /* we're in the function */
	{
		insert_str( "\n%s\n", label->name);
	}
	else
	{
		fprintf(asm_file, "\n%s\n", label->name);
	}
}

void do_global(SYMB *label, int type)
{
	if (type == EXPORT_FUNC)
	{
		insert_str( "\nglobal %s:function\n", label->name);
	}
	else if (type == EXPORT_DATA)
	{
		fprintf(asm_file, "\nglobal %s:data\n", label->name);
	}
}

void do_arg(SYMB *expr)
{
	insert_arg(expr);
	
	/* for caller to balance the stack after a function call */
        arglist->VAL++;
}

void to_eax(SYMB *expr)
{
	/* EAX <- data */
	
	if (expr->type == T_NUM)
        {
        	/* imm */
        	
                insert_str( "\tmov eax, 0x%.8X\n", expr->VAL);
        }
        else if (expr->type == T_VAR && expr->OFFSET != 0)
        {
        	/* local variable */
        	
                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr->OFFSET);
        }
        else if (expr->type == T_VAR && expr->OFFSET == 0)
        {
        	/* global variable */
        	
        	insert_str( "\tmov eax, [%s]\n", expr->name);
        }
}

SYMB* do_add(SYMB *expr1, SYMB *expr2)
{
        SYMB *s;
        
	if (expr1->type == T_NUM && expr2->type == T_NUM)
        {
		/* eg. 4 + 5 */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\tadd eax, 0x%.8X\n", expr2->VAL);
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET != 0) /* expr1 -> num , expr2 -> local */
        {
		/* eg. 4 + local_var */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tadd eax, 0x%.8X\n", expr1->VAL);
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET == 0) /* expr1 -> num , expr2 -> global */
	{
		/* eg. 4 + global_var */

                insert_str( "\tmov eax, [%s]\n", expr2->name);
                insert_str( "\tadd eax, 0x%.8X\n", expr1->VAL);
	}
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET != 0) /* expr1 -> local , expr2 -> num */
        {
		/* eg. local_var + 4 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tadd eax, 0x%.8X\n", expr2->VAL);
        }
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET == 0) /* expr1 -> global , expr2 -> num */
	{
		/* eg. global_var + 4 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\tadd eax, 0x%.8X\n", expr2->VAL);
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET != 0) /* both local variables */
        {
		/* eg. local_v1 + local_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov edx, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tadd eax, edx\n");
        }
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET == 0) /* expr1 -> local , expr2 -> global */
        {
		/* eg. local_v1 + global_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov edx, [%s]\n", expr2->name);
                insert_str( "\tadd eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET != 0) /* expr1 -> global , expr2 -> local */
        {
		/* eg. global_v1 + local_v2 */

                insert_str( "\tmov edx, [%s]\n", expr1->name);
                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tadd eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET == 0) /* both global variables */
	{
		/* eg. global_v1 + global_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\tmov edx, [%s]\n", expr2->name);
                insert_str( "\tadd eax, edx\n");
	}
	

	/* Now data has been writtent to EAX, ready for any usages. */
        
        /* This symbol is used to judge whether right-hand data is ready for
	   assignment, so its name doesn't matter. We only need to mark its
	   `type` as T_READY. */
	
	s = get_symb("");
        s->type = T_READY;

        return s;
}

SYMB* do_sub(SYMB *expr1, SYMB *expr2)
{
        SYMB *s;
        
	if (expr1->type == T_NUM && expr2->type == T_NUM) /* expr1 -> num , expr2 -> num */
        {
		/* eg. 4 - 5 */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\tsub eax, 0x%.8X\n", expr2->VAL);
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET != 0) /* expr1 -> num , expr2 -> local */
        {
		/* eg. 4 - local_var */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tsub eax, 0x%.8X\n", expr1->VAL);
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET == 0) /* expr1 -> num , expr2 -> global */
	{
		/* eg. 4 - global_var */

                insert_str( "\tmov eax, [%s]\n", expr2->name);
                insert_str( "\tsub eax, 0x%.8X\n", expr1->VAL);
	}
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET != 0) /* expr1 -> local , expr2 -> num */
        {
		/* eg. local_var - 4 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tsub eax, 0x%.8X\n", expr2->VAL);
        }
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET == 0) /* expr1 -> global , expr2 -> num */
	{
		/* eg. global_var - 4 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\tsub eax, 0x%.8X\n", expr2->VAL);
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET != 0) /* both local variables */
        {
		/* eg. local_v1 - local_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov edx, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tsub eax, edx\n");
        }
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET == 0) /* expr1 -> local , expr2 -> global */
        {
		/* eg. local_v1 - global_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov edx, [%s]\n", expr2->name);
                insert_str( "\tsub eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET != 0) /* expr1 -> global , expr2 -> local */
        {
		/* eg. global_v1 - local_v2 */

                insert_str( "\tmov edx, [%s]\n", expr1->name);
                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tsub eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET == 0) /* both global variables */
	{
		/* eg. global_v1 - global_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\tmov edx, [%s]\n", expr2->name);
                insert_str( "\tsub eax, edx\n");
	}
	
	s = get_symb("");
        s->type = T_READY;

        return s;
}

SYMB* do_mul(SYMB *expr1, SYMB *expr2)
{
        SYMB *s;
        
	if (expr1->type == T_NUM && expr2->type == T_NUM) /* expr1 -> num , expr2 -> num */
        {
		/* eg. 4 * 5 */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\timul eax, 0x%.8X\n", expr2->VAL);
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET != 0) /* expr1 -> num , expr2 -> local */
        {
		/* eg. 4 * local_var */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\timul eax, [ebp + 0x%.8X]\n", expr2->OFFSET);
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET == 0) /* expr1 -> num , expr2 -> global */
        {
		/* eg. 4 * global_var */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\timul eax, [%s]\n", expr2->name);
	}
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET != 0) /* expr1 -> local , expr2 -> num */
        {
		/* eg. local_var * 4 */

                insert_str( "\tmov eax, 0x%.8X\n", expr2->VAL);
                insert_str( "\timul eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
        }
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET == 0) /* expr1 -> global , expr2 -> num */
        {
		/* eg. global_var * 4 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\timul eax, 0x%.8X\n", expr2->VAL);
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET != 0) /* both local variables */
        {
		/* eg. local_v1 * local_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\timul eax, [ebp + 0x%.8X]\n", expr2->OFFSET);
        }
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET != 0) /* expr1 -> global , expr2 -> local */
        {
		/* eg. global_v1 * local_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\timul eax, [ebp + 0x%.8X]\n", expr2->OFFSET);
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET == 0) /* expr1 -> local , expr2 -> global */
        {
		/* eg. local_v1 * global_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov eax, [%s]\n", expr2->name);
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET == 0) /* both global variables */
        {
		/* eg. global_v1 * global_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\timul eax, [%s]\n", expr2->name);
	}

	s = get_symb("");
        s->type = T_READY;

        return s;
}

SYMB* do_div(SYMB *expr1, SYMB *expr2)
{
        SYMB *s;
        
        if (expr1->type == T_NUM && expr2->type == T_NUM) /* expr1 -> num , expr2 -> num */
        {
		/* eg. 4 / 5 */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\tmov ecx, 0x%.8X\n", expr2->VAL);
                insert_str( "\tcdq\n"); /* EDX:EAX <- SignEx(EAX) */
                insert_str( "\tidiv ecx\n"); /* EAX = EDX:EAX / ECX */
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET != 0) /* expr1 -> num , expr2 -> local */
        {
		/* eg. 4 / local_var */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
		insert_str( "\tmov ecx, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET == 0) /* expr1 -> num , expr2 -> global */
        {
		/* eg. 4 / global_var */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
		insert_str( "\tmov ecx, [%s]\n", expr2->name);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET != 0) /* expr1 -> local , expr2 -> num */
        {
		/* eg. local_var / 4 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
		insert_str( "\tmov ecx, 0x%.8X\n", expr2->VAL);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
        }
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET == 0) /* expr1 -> global , expr2 -> num */
        {
		/* eg. global_var / 4 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
		insert_str( "\tmov ecx, 0x%.8X\n", expr2->VAL);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET != 0) /* both local variables */
        {
		/* eg. local_v1 / local_v2 */
		
                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
		insert_str( "\tmov ecx, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
        }
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET != 0) /* expr1 -> global , expr2 -> local */
        {
		/* eg. global_v1 * local_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
		insert_str( "\tmov ecx, [ebp + 0x%8X]\n", expr2->OFFSET);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET == 0) /* expr1 -> local , expr2 -> global */
        {
		/* eg. local_v1 * global_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
		insert_str( "\tmov ecx, [%s]\n", expr2->name);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET == 0) /* both global variables */
        {
		/* eg. global_v1 / global_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
		insert_str( "\tmov ecx, [%s]\n", expr2->name);
                insert_str( "\tcdq\n");
                insert_str( "\tidiv ecx\n");
	}

	s = get_symb("");
        s->type = T_READY;

        return s;
}

SYMB* do_rela(char *code, SYMB *expr1, SYMB *expr2)
/* `code` can be:
    "ja" for ">";
    "jae" for ">=" ;
    "jl" for "<" ;
    "jle" for "<=" ;
    "je" for "==" ;
    "jne" for "!=" .
 */
{
        SYMB *s;
        
        /* do comparation */
        
	if (expr1->type == T_NUM && expr2->type == T_NUM) /* expr1 -> num , expr2 -> num */
        {
		/* eg. 4 rela_op 5 */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\tcmp eax, 0x%.8X\n", expr2->VAL);
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET != 0) /* expr1 -> num , expr2 -> local */
        {
		/* eg. 4 rela_op local_var */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\tmov edx, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tcmp eax, edx\n");
        }
        else if (expr1->type == T_NUM && expr2->type == T_VAR &&
		expr2->OFFSET == 0) /* expr1 -> num , expr2 -> global */
	{
		/* eg. 4 rela_op global_var */

                insert_str( "\tmov eax, 0x%.8X\n", expr1->VAL);
                insert_str( "\tmov edx, [%s]\n", expr2->name);
                insert_str( "\tcmp eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET != 0) /* expr1 -> local , expr2 -> num */
        {
		/* eg. local_var rela_op 4 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov edx, 0x%.8X\n", expr2->VAL);
                insert_str( "\tcmp eax, edx\n");
        }
        else if (expr1->type == T_VAR && expr2->type == T_NUM &&
		expr1->OFFSET == 0) /* expr1 -> global , expr2 -> num */
	{
		/* eg. global_var rela_op 4 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\tmov edx, 0x%.8X\n", expr2->VAL);
                insert_str( "\tcmp eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET != 0) /* both local variables */
        {
		/* eg. local_v1 rela_op local_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov edx, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tcmp eax, edx\n");
        }
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET != 0 && expr2->OFFSET == 0) /* expr1 -> local , expr2 -> global */
        {
		/* eg. local_v1 rela_op global_v2 */

                insert_str( "\tmov eax, [ebp + 0x%.8X]\n", expr1->OFFSET);
                insert_str( "\tmov edx, [%s]\n", expr2->name);
                insert_str( "\tcmp eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET != 0) /* expr1 -> global , expr2 -> local */
        {
		/* eg. global_v1 rela_op local_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\tmov edx, [ebp + 0x%.8X]\n", expr2->OFFSET);
                insert_str( "\tcmp eax, edx\n");
	}
        else if (expr1->type == T_VAR && expr2->type == T_VAR &&
		expr1->OFFSET == 0 && expr2->OFFSET == 0) /* both global variables */
	{
		/* eg. global_v1 rela_op global_v2 */

                insert_str( "\tmov eax, [%s]\n", expr1->name);
                insert_str( "\tmov edx, [%s]\n", expr2->name);
                insert_str( "\tcmp eax, edx\n");
	}
	
	/* construct assignment codes */
	
	insert_str( "\t%s .cmp%d\n", code, next_cmp_label);
        insert_str( "\tmov eax, 0\n" );
        insert_str( "\tjmp .cmp%d\n", next_cmp_label + 1);
        insert_str( ".cmp%d:\n", next_cmp_label);
        insert_str( "\tmov eax, 1\n" );
        insert_str( ".cmp%d:\n", next_cmp_label + 1);
        next_cmp_label += 2;
	
	s = get_symb("");
        s->type = T_READY;

        return s;
}

SYMB* do_uminus(SYMB *expr)
{
        SYMB *s;
        
	to_eax(expr);
        insert_str( "\tneg eax\n");
        
        s = get_symb("");
        s->type = T_READY;
        
        return s;        
}

SYMB* do_call(SYMB *label)
{
	SYMB *s;
	
	/* pass parameters from right-hand to left hand. */
	
	s = arglist->next;
	while (s)
	{
		if (s->type == T_VAR)
		{
			to_eax(s);
			insert_str( "\tpush eax\n");
		}
		else if (s->type == T_NUM)
		{
			insert_str( "\tpush 0x%.8X\n", s->VAL);
		}
		
		s = s->next;
	}
	arglist->next = NULL; /* clear it for the next function call. */

	/* all parameters passed, so we can call the function. */
	insert_str( "\tcall %s\n", label->name);

	/* caller balances the stack after a function call. */

	if (arglist->VAL > 0)
	{
		insert_str( "\tadd esp, 0x%.8x\n", arglist->VAL * VAR_OFFSET);
		arglist->VAL = 0; /* clear it for the next function call. */
	}

	/* Data has been returned to EAX, ready for any usages. */

	s = get_symb("");
	s->type = T_READY;

	return s;
}

void yyerror(char *err)
{
	printf("yac error: %s\n", err);
	printf("line: %d, before \"%s\"\n", yylineno, yytext);
}

