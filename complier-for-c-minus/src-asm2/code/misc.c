#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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



