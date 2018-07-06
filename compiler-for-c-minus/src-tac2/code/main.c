#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"
#include "y.tab.h"

extern FILE *yyin;

TAC*	program_tac;
FILE    *tac_file;
SYMB	*symb_list; /* for symbols with the type `T_NUM` & `T_LABEL` */
SYMB    *symbtabs[MAX_SCOPE][HASHSIZE];
SYMB	**current_symbtab; /* symbol table for current scope */
int	next_local_scope;
int     next_temp;
int     next_label;


int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		printf("Usage: %s <file_name>\n", argv[0]);
		return 1;
	}
	
	init_tac();
	
	setup_files(argv[1]);

	yyin = fopen(argv[1], "r");
	if (yyin == NULL)
	{
		printf("invalid input file\n");
		return 1;
	}
	yyparse();

	fclose(yyin);

	print_tac(program_tac);

	cleanup_tac();

	return 0;
}


SYMB* get_symb(char *text)
{
	SYMB* s = (SYMB*) malloc(sizeof(SYMB));
	
	/* mark it as T_UNDEF and fill its name */
	
	s->type = T_UNDEF;
	s->TEXT = (char*) malloc(strlen(text) + 1);
	strcpy(s->TEXT, text);
	
	return s;
}

void print_symbs() /* this routine is used for debugging */
{
	int i, j;
	SYMB *s;
	
	printf("\n+++++ symbs starts +++++\n");

	for (i = 0; i < MAX_SCOPE; i++)
	{
		for (j = 0; j < HASHSIZE; j++)
		{
			if (symbtabs[i][j])
			{
		        	printf("symbtabs[%d][%d] type: %d, name or val: %s\n",
		                	i, j, symbtabs[i][j]->type, ts(symbtabs[i][j]));
			}
		}
	}
	
	i = 0;
	s = symb_list;
	while (s)
	{
		if (s->type == T_NUM)
		{
			printf("symb_list[%d] NUM, %d\n", i, s->VAL);
		}
		else if (s->type == T_LABEL)
		{
			printf("symb_list[%d] LABEL, L%d\n", i, s->VAL);
		}
		i++;
		s = s->next;
	}
	
	printf("+++++ symbs end +++++\n\n");
}

void free_symbs()
{
	int i, j;
	
	for (i = 0; i < MAX_SCOPE; i++)
	{
		for (j = 0; j < HASHSIZE; j++)
		{
			if (symbtabs[i][j])
			{
				switch (symbtabs[i][j]->type)
				{
					case T_VAR:
					case T_FUNC:
						free(symbtabs[i][j]->TEXT);
						break;
				}
				
				free(symbtabs[i][j]);
				symbtabs[i][j] = NULL;
			}
		}
	}
}

char* int2str(int i, char* str)
{
        sprintf(str, "%d", i);
        
        return str;
}

char* ts(SYMB* symb)
{
	char str[16];
	
	switch (symb->type)
	{
		case T_NUM:
		case T_LABEL:
			return int2str(symb->VAL, str);
		case T_VAR:
		case T_FUNC:
			return symb->TEXT;
		
	}
	
	return NULL;
}

void init_tac()
{
        int i, j;
        
        program_tac = (TAC*) malloc(sizeof(TAC));
        program_tac->prev = NULL;
        program_tac->next = NULL;
        
        symb_list = (SYMB*) malloc(sizeof(SYMB));
        symb_list->next = NULL;
        
        /* clear symbtabs */
        
        for (i = 0; i < MAX_SCOPE; i++)
        {
                for (j = 0; j < HASHSIZE; j++)
                        symbtabs[i][j] = NULL;
        }
        
        current_symbtab  = symbtabs[GLOBAL_SCOPE];
        next_local_scope = FIRST_LOCAL_SCOPE;
        next_temp  = 0;
        next_label = 0;
        
}

void cleanup_tac()
{
	TAC *t, *p;
	SYMB *s, *r;
	
	t = program_tac;
	while (t)
	{
		p = t->next;
		free(t);
		t = p;
	}
	
	s = symb_list;
	while (s)
	{
		r = s->next;
		free(s);
		s = r;
	}
	
	fclose(tac_file);
	free_symbs();
}

void setup_files(char *ifile)
{
	char *p;
	char ofile[64];
	
	strcpy(ofile, ifile);
	p = strchr(ofile, '.');
	*(p + 1) = 0;
	strcpy(p, ".tac");
	
	tac_file = fopen(ofile, "w");
}

void print_tac(TAC* tac)
{
	TAC* t = tac;
	
	while (t != NULL)
	{
		switch (t->op)
		{
			case TAC_ADD:
				fprintf(tac_file, "\t%s = %s + %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
	
			case TAC_SUB:
				fprintf(tac_file, "\t%s = %s - %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
	
			case TAC_MUL:
				fprintf(tac_file, "\t%s = %s * %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
	
			case TAC_DIV:
				fprintf(tac_file, "\t%s = %s / %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
				
			case TAC_GREATER:
				fprintf(tac_file, "\t%s = %s > %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
	
			case TAC_GREATER_EQUAL:
				fprintf(tac_file, "\t%s = %s >= %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
	
			case TAC_LESS:
				fprintf(tac_file, "\t%s = %s < %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
	
			case TAC_LESS_EQUAL:
				fprintf(tac_file, "\t%s = %s <= %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
				
			case TAC_EQUAL:
				fprintf(tac_file, "\t%s = %s == %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
				
			case TAC_NOT_EQUAL:
				fprintf(tac_file, "\t%s = %s != %s\n", ts(t->VA),
					ts(t->VB), ts(t->VC));
				break;
	
			case TAC_UMINUS:
				fprintf(tac_file, "\t%s = - %s\n", ts(t->VA), ts(t->VB));
				break;
				
			case TAC_ASSIGN:
			        fprintf(tac_file, "\t%s = %s\n", ts(t->VA), ts(t->VB));
			        break;
			        
			case TAC_IFNZ:
			        fprintf(tac_file, "\tifnz %s goto L%s\n", ts(t->VA), ts(t->VB));
			        break;
			        
			case TAC_GOTO:
			        fprintf(tac_file, "\tgoto L%s\n", ts(t->VA));
			        break;
			        
			case TAC_LABEL:
			        fprintf(tac_file, "L%s:\n", ts(t->VA));
			        break;
			        
			case TAC_VAR_DECL:
			        fprintf(tac_file, "\tint %s\n", ts(t->VA));
			        break;
		        
		        case TAC_FUNC:
		        	fprintf(tac_file, "\n\tfunction %s\n", ts(t->VA));
		        	fprintf(tac_file, "%s:\n", ts(t->VA));
		        	break;
		        	
	        	case TAC_BEGIN_FUNC:
	        		fprintf(tac_file, "\tbeginfunc\n");
	        		break;
	        		
	        	case TAC_END_FUNC:
	        		fprintf(tac_file, "\tendfunc\n");
	        		break;
		        	
	        	case TAC_PARAM:
	        		fprintf(tac_file, "\tint_param %s\n", ts(t->VA));
	        		break;
	        		
        		case TAC_RETURN:
        			fprintf(tac_file, "\treturn %s\n", ts(t->VA));
        			break;
        			
			case TAC_ARG:
				fprintf(tac_file, "\targ %s\n", ts(t->VA));
				break;
				
			case TAC_CALL:
				fprintf(tac_file, "\t%s = call %s\n", ts(t->VA), ts(t->VB));
				break;
	
		}
		t = t->next;
	}
}


