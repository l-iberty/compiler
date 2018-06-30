#ifndef TAC_H
#define TAC_H

#define HASHSIZE          997
#define MAX_SCOPE	  256
#define GLOBAL_SCOPE	  0
#define FIRST_LOCAL_SCOPE 1

#define T_UNDEF		0
#define T_VAR		1
#define T_NUM		2
#define T_LABEL		3
#define T_FUNC		4

#define TAC_ADD		        0x100
#define TAC_SUB		        0x101
#define TAC_MUL		        0x102
#define TAC_DIV		        0x103
#define TAC_UMINUS	        0x104
#define TAC_ASSIGN	        0x105
#define TAC_IFNZ                0x106
#define TAC_GOTO                0x107
#define TAC_LABEL               0x108
#define TAC_VAR_DECL	        0x109
#define TAC_FUNC	        0x10A
#define TAC_BEGIN_FUNC	        0x10B
#define TAC_END_FUNC	        0x10C
#define TAC_PARAM	        0x10D
#define TAC_ARG		        0x10E
#define TAC_RETURN	        0x10F
#define TAC_GREATER_EQUAL       0x110
#define TAC_LESS_EQUAL   	0x111
#define TAC_GREATER		0x112
#define TAC_LESS		0x113
#define TAC_NOT_EQUAL		0x114
#define TAC_EQUAL		0x115
#define TAC_CALL                0x116

typedef struct symb
{
	struct symb *next; /* for labels and numbers */
        int type;
        union
        {
                char *text;
                int   val;
        } u;
} SYMB;

#define TEXT    u.text
#define VAL     u.val

typedef struct tac
{
        struct tac *prev;  /* for extension */
        struct tac *next;
        int op;
        union
        {
                struct symb *a;
                struct tac  *la;
        } u1;
        union
        {
                struct symb *b;
                struct tac  *lb;
        } u2;
        union
        {
                struct symb *c;
                struct tac  *lc;
        } u3;
} TAC;

#define VA      u1.a
#define LA      u1.la
#define VB      u2.b
#define LB      u2.lb
#define VC      u3.c
#define LV	u3.lc

typedef struct enode
{
	struct enode	*prev;  /* for extension */
        struct enode    *next;  /* for arguments */
	struct tac	*code;
	struct symb	*res;
} ENODE;

extern FILE	*tac_file;
extern SYMB	*symb_list;
extern SYMB     *symbtabs[MAX_SCOPE][HASHSIZE];
extern SYMB	**current_symbtab;
extern int	next_local_scope;
extern int      next_temp;
extern int      next_label;
extern TAC*	program_tac;

int	hash(char *text);
void	insert(SYMB *s);
void	insert_list(SYMB *s);
SYMB*	lookup(SYMB *tab[], char *text);
SYMB*	get_symb(char *text);
void	print_symbs();
void	free_symbs();
char*	ts(SYMB* symb);
char*   int2str(int i);
void	init_tac();
void	cleanup_tac();
void	setup_files(char *ifile);
void	print_tac(TAC *tac);


#endif // TAC_H

