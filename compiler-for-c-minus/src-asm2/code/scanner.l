%option yylineno

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asm.h"
#include "y.tab.h"

%}

digit           [0-9]
letter          [a-z|A-Z]
operator        "+"|"-"|"*"|"/"|"="
identifier      {letter}({letter}|{digit})*
label           {identifier}:
whitespace	[ \t\n\r]*

%%

">="            { return GREATER_EQUAL ;  }
"<="            { return LESS_EQUAL ;     }
">"             { return GREATER ;        }
"<"             { return LESS ;           }
"=="            { return EQUAL;           }
"!="            { return NOT_EQUAL;       }
{digit}+        { mkconst( yytext );
		  return NUM;             }
{operator}      { return *yytext;         }
function	{ return FUNCTION;	  }
beginfunc	{ return BEGIN_FUNC;      }
endfunc		{ return END_FUNC;        }
int		{ return VAR_INT;         }
int_param	{ return INT_PARAM;	  }
ifz             { return IFZ;             }
ifnz            { return IFNZ;            }
goto            { return GOTO;            }
arg             { return ARG;             }
call            { return CALL;            }
return          { return RETURN;          }
{label}		{ mklabel( yytext );
		  return LABEL;           }
{identifier}	{ mkvar( yytext );
		  return IDENTIFIER;      }
{whitespace}	{ /* ignore whitespace */ }
.		{
			printf("lex error: undefined text: %s", yytext);
			exit(1);
		}

%%

void mkvar( char *text )
{
        SYMB *symb;
        
        symb = lookup(current_symbtab, text);
        if (symb != NULL)
        {
                yylval.symb = symb;
                return;
        }
        
        symb = get_symb(text);
        symb->type = T_VAR;
	symb->OFFSET = 0;
        
        yylval.symb = symb;
}

void mkconst( char *text )
{
        SYMB *symb;
        
        symb = lookup(current_symbtab, text);
        if (symb != NULL)
        {
                yylval.symb = symb;
                return;
        }
        
        symb = get_symb(text);
        symb->type = T_NUM;
        symb->VAL = atoi(text);
        
        yylval.symb = symb;
}

void mklabel( char *text )
{
        SYMB *symb;
        
        symb = lookup(current_symbtab, text);
        if (symb != NULL)
        {
                yylval.symb = symb;
                return;
        }
        
        symb = get_symb(text);
        symb->type = T_LABEL;
        
        yylval.symb = symb;
}


