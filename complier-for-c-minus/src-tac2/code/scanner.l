%option yylineno

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"
#include "y.tab.h"

SYMB*	mkid(char *text);
SYMB*	mkconst(char *text);

%}

digit           [0-9]
letter          [a-z|A-Z]
operator        "+"|"-"|"*"|"/"|"="
identifier      {letter}({letter}|{digit})*
number          {digit}+
whitespace	[ \t\n\r]*
comment         "//".*

%%

int		{ return INT;		}
if              { return IF;       	}
else            { return ELSE;     	}
while           { return WHILE;    	}
for		{ return FOR;		}
return		{ return RETURN;	}
">="		{ return GREATER_EQUAL; }
"<="		{ return LESS_EQUAL;	}
"=="		{ return EQUAL;		}
"!="		{ return NOT_EQUAL;	}
{identifier}    { mkid( yytext );
		  return IDENTIFIER; 	}
{number}        { mkconst( yytext );
		  return NUMBER;   	}
{whitespace}	{ /* ignore whitespace */ }
{comment}       { /* ignore comment */  }
.		{ return *yytext;	}

%%

SYMB* mkid( char *text )
{
        SYMB *s;
        
        s = lookup(current_symbtab, text);
        if (s != NULL)
        {
                yylval.symb = s;
                return s;
        }
        
        s = lookup(symbtabs[GLOBAL_SCOPE], text);
        if (s != NULL)
        {
                yylval.symb = s;
                return s;
        }
        
        s = get_symb(text);
        s->type = T_UNDEF;
        
        yylval.symb = s;
        return s;
}

SYMB* mkconst( char *text )
{
        SYMB *s;
        
        s = get_symb(text);
        s->type = T_NUM;
        s->VAL = atoi(text);
        
        insert_list(s);

        yylval.symb = s;
        return s;
}


