#ifndef ASM_H
#define ASM_H

#include <stdio.h>

#define TRUE	1
#define FALSE	0

#define HASHSIZE		997
#define SCOPE_MAX		256
#define GLOBAL_SCOPE		0
#define FIRST_LOCAL_SCOPE	1
#define VAR_OFFSET		4
#define PARAM_OFFSET_BEGIN	4
#define MIN_LOCAL_MEM_SIZE      16

#define T_UNDEF		0
#define T_READY		1
#define T_VAR	        2
#define T_NUM	        3
#define T_LABEL         4

#define EXPORT_FUNC     1
#define EXPORT_DATA     2

#define VAL	        u.val
#define OFFSET	        u.offset


typedef struct symb
{
	char	*name;
	int     type;
	union {
		int	val;	/* as for NUM, record its value */
		int	offset;	/* as for VARIABLE, record its offset to EBP */
	} u;
	struct symb *next;
} SYMB;

typedef struct strnode
{
        char *str;
        struct strnode *next;
} STRNODE;

extern FILE     *asm_file;
extern SYMB     *symbtabs[SCOPE_MAX][HASHSIZE];
extern SYMB     **current_symbtab;
extern SYMB     *arglist;
extern STRNODE  *strlist;
extern STRNODE	*pnode;
extern int      next_local_scope;
extern int	local_mem_size;
extern int      local_var_off;
extern int      param_off;
extern int      flag_code_seg;
extern int      next_cmp_label;

void    init_asm();
int     hash(char *text);
void    insert(SYMB *text);
SYMB*   lookup(SYMB *symbtab[], char *text);
SYMB*   get_symb(char *text);

void    mkvar(char *text);
void    mkconst(char *text);
void    mklabel(char *text);
void    print_symbtabs();
void    free_symbtabs();

void    init_arglist();
void    insert_arg(SYMB *arg);
void    free_arglist();

void    init_strlist();
STRNODE *insert_str(char *fmt, ...);
void    print_strlist();
void    free_strlist();

void    begin_func(SYMB *func, SYMB *label);
void    end_func();
void    declare_var(SYMB *var);
void    declare_param(SYMB *param);
void    do_assign(SYMB *left, SYMB *right);
void    do_return(SYMB *expr);
void    do_jz(SYMB *expr, SYMB *label);
void    do_jnz(SYMB *expr, SYMB *label);
void    do_jmp(SYMB *label);
void    do_label(SYMB *label);
void    do_global(SYMB *label, int type);
void    do_arg(SYMB *expr);
void    to_eax(SYMB *expr);
SYMB*   do_add(SYMB *expr1, SYMB *expr2);
SYMB*   do_sub(SYMB *expr1, SYMB *expr2);
SYMB*   do_mul(SYMB *expr1, SYMB *expr2);
SYMB*   do_div(SYMB *expr1, SYMB *expr2);
SYMB*   do_rela(char *code, SYMB *expr1, SYMB *expr2);
SYMB*   do_uminus(SYMB *expr);
SYMB*   do_call(SYMB *label);


#endif // ASM_H

