#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "asm.h"

FILE *asm_file;

SYMB    *symbtabs[SCOPE_MAX][HASHSIZE];
SYMB    **current_symbtab;
SYMB    *arglist;		/* used for passing parameters to function in right-to-left order */
STRNODE	*strlist;
STRNODE *pnode;			/* point to "sub esp, 0" which needs correcting */
int     next_local_scope;	/* which local scope are we in now? */
int	local_mem_size;		/* how many bytes of local memory space are needed? */
int     local_var_off;
int     param_off;
int	flag_code_seg;		/* are we in the code segment */
int     next_cmp_label;         /* for relation-op */

void init_asm()
{
	int i, j;

	asm_file = fopen("out.asm", "w");
	
	/* begin with data segment */
	
	fprintf(asm_file, "[section .data]\n\n");

	/* clear symbol table */
	for (i = 0; i < SCOPE_MAX; i++)
	{
		for (j = 0; j < HASHSIZE; j++)
			symbtabs[i][j] = NULL;
	}

	current_symbtab = symbtabs[GLOBAL_SCOPE];
	next_local_scope = FIRST_LOCAL_SCOPE;
	local_mem_size = MIN_LOCAL_MEM_SIZE;
	local_var_off = 0;
	
	next_cmp_label = 0;
	
	init_arglist();
}

int hash(char *text)
{
	int hv = 0;
	
	for(int i = 0; text[i]; i++)
	{
		int v = (hv >> 28) ^ (text[i] & 0xf);
		hv = (hv << 4) | v;
	}
	
	hv = hv & 0x7fffffff;	 /* Ensure positive */
	return (hv % HASHSIZE);
}

void insert(SYMB *s)
{
        int hv = hash(s->name);
        
	int i;
        for (i = 0; i < HASHSIZE; i++)
        {
                if (current_symbtab[hv] != NULL)
                        hv = (hv + 1) % HASHSIZE;
                else
                        break;
        }
        
        if (i < HASHSIZE)
                current_symbtab[hv] = s; /* put it into symbol table */
        else
                printf("insert error\n"); /* no free slot found */
}

SYMB* lookup(SYMB *symbtab[], char *text)
{
        int hv = hash(text);
        
        int i;
        for (i = 0; i < HASHSIZE; i++)
        {
                if (symbtab[hv] != NULL)
                {
                        if (!strcmp(symbtab[hv]->name, text))
                                return symbtab[hv]; /* found */
                }
                hv = (hv + 1) % HASHSIZE; /* try next slot */
        }
        
        return NULL; /* not found */
}

SYMB* get_symb(char *text)
{
	SYMB* s = (SYMB*)malloc(sizeof(SYMB));
	
	/* mark it as T_UNDEF and fill its name */
	
	s->type = T_UNDEF;
	s->name = (char*)malloc(strlen(text) + 1);
	strcpy(s->name, text);
	
	return s;
}

void print_symbtabs() /* this routine is used for debugging */
{
	printf("\n+++++ symbtabs start +++++\n");

	for (int i = 0; i < SCOPE_MAX; i++)
	{
		for (int j = 0; j < HASHSIZE; j++)
		{
			if (symbtabs[i][j])
			{
				printf("symbtabs[%d][%d] -> %s (0x%.8X)\n",
					i, j, symbtabs[i][j]->name, symbtabs[i][j]->OFFSET);
			}
		}
	}
	
	printf("+++++ symbtabs end +++++\n\n");
}

void free_symbtabs()
{
	for (int i = 0; i < SCOPE_MAX; i++)
	{
		for (int j = 0; j < HASHSIZE; j++)
		{
			if (symbtabs[i][j])
			{
				free(symbtabs[i][j]);
				symbtabs[i][j] = NULL;
			}
		}
	}
}

void init_arglist()
{
        arglist = (SYMB*)malloc(sizeof(SYMB));
        
        arglist->VAL	= 0; /* we need to record the number parameters
        			so that caller can balance the stack correctly. */
        arglist->next	= NULL;
}

void insert_arg(SYMB *arg)
{
	/* NOTE we don't create a new one, just link it to the list */
	
        arg->next = arglist->next; /* insert at head */
        arglist->next = arg;
}

void free_arglist()
{
        if (arglist != NULL)
        {
                free(arglist);
                arglist = NULL;
        }
}


void init_strlist()
{
	strlist = (STRNODE*)malloc(sizeof(STRNODE));
	strlist->next = NULL;
}

STRNODE *insert_str(char *fmt, ...)
{
	STRNODE *node, *tail;
	va_list arg;
	char s[64];
	
	va_start( arg, fmt );
	vsprintf(s, fmt, arg);
	
	node = (STRNODE*)malloc(sizeof(STRNODE));
	node->str = (char*)malloc(strlen(s) + 1);
	strcpy(node->str, s);
	node->next = NULL;
	
	/* insert at tail */

	for (tail = strlist; tail->next; tail = tail->next) {}
	
	tail->next = node;

	return node;
}

void print_strlist()
{
	STRNODE *p;
	
	for (p = strlist->next; p; p = p->next)
	{
		fprintf(asm_file, "%s", p->str);
	}
}

void free_strlist()
{
	STRNODE *prev, *cur;
	prev = strlist;
	while (prev != NULL)
	{
		cur = prev->next;
		free(prev);
		prev = cur;
	}
	strlist = NULL;
}



