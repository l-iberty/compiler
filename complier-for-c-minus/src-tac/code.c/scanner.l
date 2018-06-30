%{
/******************************************************************************
*******************************************************************************


      SSSSSS     CCCCC     AAAA    NN    NN  NN    NN  EEEEEEEE  RRRRRRR 
     SSSSSSSS   CCCCCCC   AAAAAA   NNN   NN  NNN   NN  EEEEEEEE  RRRRRRRR
     SS        CC        AA    AA  NNNN  NN  NNNN  NN  EE        RR    RR
     SSSSSSS   CC        AAAAAAAA  NN NN NN  NN NN NN  EEEEEE    RRRRRRRR
           SS  CC        AA    AA  NN  NNNN  NN  NNNN  EE        RRRRRRR 
           SS  CC        AA    AA  NN  NNNN  NN  NNNN  EE        RR  RR  
     SSSSSSSS   CCCCCCC  AA    AA  NN   NNN  NN   NNN  EEEEEEEE  RR   RR 
      SSSSSS     CCCCC   AA    AA  NN    NN  NN    NN  EEEEEEEE  RR    RR


*******************************************************************************
*******************************************************************************

                              A Compiler for VSL
                              ==================
   A scanner for VSL

   Modifications:
   ==============

   16 Nov 88 JPB:  First version
   26 Apr 89 JPB:  Simple version
   25 Jul 89 JPB:  Final version for publication
   23 Jan 96 JPB:  Various minor corrections for 2nd edition publication.

*******************************************************************************
******************************************************************************/

#include <stdio.h>
#include <ctype.h>
#include "vc.h"
#include "parser.h"

/* Routines defined here. These are in the code section below and build symbol
   table entries for variable names, integer constants and text strings
   respectively. */ 

void  mkname( char *name ) ;
void  mkval( void ) ;
void  mktext( void ) ;

/* We define some useful patters using regular expressions as described in
   chapter 5. Note how earlier definitions are used later (e.g. the definition
   of "delimiter" in the definition of "whitespace". These patterns are very
   straightforward, since all VSL reserved words use upper case letters and
   variable names use only lower case. */

%}

comment         "//".*
delimiter       [ \t\n\r]
whitespace      {delimiter}+
uc_letter       [A-Z]
lc_letter       [a-z]
letter          {lc_letter}|{uc_letter}
ascii_char      [^\"\n]
escaped_char    \\n|\\\"
digit           [0-9]
variable        {lc_letter}({lc_letter}|{digit})*
integer         {digit}+

%{
/* Now follows the rule section. We wish to return the appropriate token in
   each case. We start with rules to ignore comments (everything from // to the
   end of line) and white space. Then come the three complex lexemes,
   "variable", "integer" and "text". In each case we call "mkxxx()" to build an
   appropriate symbol table entry from "yytext" and put the result in "yylval",
   as the attribute to go back with the token.

   We then include patterns to recognise the assign symbol, ":=", and the
   reserved words.

   Anything that has not been recognised will then be picked up by the last
   match, which is for single character tokens. This will only be used if
   nothing longer can be matched. Single character variables and integers will
   not be picked up by this, even though they are the same length, because
   their rule is specified earlier. An alternative approach would be to specify
   the individual single character tokens that are permissible and return an
   "ERROR" token for any other single character. The arrangement as it stands
   leaves detection of such errors to the parser. */
%}

%%

">="            { return GREATER_EQUAL ;  }
"<="            { return LESS_EQUAL ;     }
">"             { return GREATER ;        }
"<"             { return LESS ;           }
"=="            { return EQUAL;           }
"!="            { return NOT_EQUAL;       }
"="             { return ASSIGN_SYMBOL ;  }
return          { return RETURN ;         }
if              { return IF ;             }
else            { return ELSE ;           }
while           { return WHILE ;          }
int             { return VAR_INT ;        }
{comment}       {                        /* Ignore comments */ }
{whitespace}    {                        /* Ignore whitespace */ }
{variable}      { mkname( yytext ) ;     /* Save the variable name */
                  return VARIABLE ;      /* A variable name */ }
{integer}       { mkval() ;              /* Save the integer value */
                  return INTEGER ;       /* A number */ }
.               { return yytext[0] ;     /* Single character operator */ }

%%

/* Support code */


void  mkname( char *name )

/* Lookup a name in the symbol table. If not there set up a new one, returning
   the result in "yylval". Note that "yylval" is a union, defined in parser.h
   and so we must specify which member of the union (in this case "symb") we
   wish to used. We insert the name in the symbol table, but at this stage with
   type T_UNDEF, since we do not know what its type is. */

{
        struct symb *t ;                 /* Pointer to looked up symbol */
        char        *s ;                 /* Permanent text of string */
        int          len ;               /* Length of text */


        /* If the string exists return with it in yylval */

        if ((t = lookup( current_symbtab, name )) != NULL )
        {
                yylval.symb = t ;
                return ;
        }

	if ((t = lookup( symbtabs[GLOBAL_SCOPE], name )) != NULL )
        {
                yylval.symb = t ;
                return ;
        }

        /* Unseen before, so make a permanent copy, set up a new symbol table
           node, insert it into the symbol table and assign it to yylval. */

        len = strlen( name ) ;
        s   = (char *)safe_malloc( len + 1 ) ; /* Space for perm copy */

        strncpy( s, name, len ) ;
        s[len] = EOS ;

        t        = get_symb() ;
        t->type  = T_UNDEF ;             /* Don't know which node type yet */
        t->TEXT1 = s ;                   /* Text argument */
        
        insert( t ) ;
        yylval.symb = t ;                /* Symbol type in union */
        
}       /* void  mkname( char *name ) */


void  mkval( void )

/* Set up a node for an integer read by the scanner. We use the library routine
   "atoi()" to convert the text of "yytext" to an integer. */

{
        yylval.symb = mkconst( atoi( yytext )) ;

}       /* void  mkval( void ) */


void  mktext( void )

/* Text is treated very similarly to a variable name. "mktext()" uses
   "mkname()" to do most of the work, and then just changes the relevant
   fields. Strings will be put out as constant data at the end of the program
   and we give it a label to mark its beginning. Note that there is no risk of
   a piece of text being mistaken for a variable name during symbol lookup,
   since the text field of a text node includes the surrounding quotes. */

{
        mkname( yytext ) ;
        yylval.symb->type = T_TEXT ;
        yylval.symb->VAL2 = next_label++ ;

}       /* mktext( void ) */
