#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "tac.h"



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
        int hv = hash(s->TEXT);
        
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

void insert_list(SYMB *s)
{
	s->next = symb_list->next; /* insert at head */
	symb_list->next = s;
}

SYMB* lookup(SYMB *symbtab[], char *text)
{
        int hv = hash(text);
        
        for (int i = 0; i < HASHSIZE; i++)
        {
                if (symbtab[hv] != NULL)
                {
                        if (!strcmp(symbtab[hv]->TEXT, text))
                                return symbtab[hv]; /* found */
                }
                hv = (hv + 1) % HASHSIZE; /* try next slot */
        }
        
        return NULL; /* not found */
}


