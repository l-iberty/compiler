#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "asm.h"
#include "y.tab.h"

extern FILE *yyin;

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		printf("Usage: %s <file_name>\n", argv[0]);
		return 1;
	}

	init_asm();

	yyin = fopen(argv[1], "r");
	if (yyin == NULL)
	{
		printf("invalid input file\n");
		return 1;
	}
	yyparse();

	fclose(yyin);
	
	cleanup_asm();

	return 0;
}

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

void cleanup_asm()
{
        fclose(asm_file);
	free_symbtabs();
	free_arglist();
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
	
        SYMB *s;
        
        s = arglist;
        while (s->next != NULL)
        	s = s->next;
        
        s->next   = arg; /* insert at tail */
        arg->next = NULL;
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
