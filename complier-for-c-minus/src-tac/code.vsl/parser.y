/******************************************************************************
*******************************************************************************


          PPPPPPP     AAAA    RRRRRRR    SSSSSS   EEEEEEEE  RRRRRRR 
          PPPPPPPP   AAAAAA   RRRRRRRR  SSSSSSSS  EEEEEEEE  RRRRRRRR
          PP    PP  AA    AA  RR    RR  SS        EE        RR    RR
          PPPPPPP   AAAAAAAA  RRRRRRRR  SSSSSSS   EEEEEE    RRRRRRRR
          PP        AA    AA  RRRRRRR         SS  EE        RRRRRRR 
          PP        AA    AA  RR  RR          SS  EE        RR  RR  
          PP        AA    AA  RR   RR   SSSSSSSS  EEEEEEEE  RR   RR 
          PP        AA    AA  RR    RR   SSSSSS   EEEEEEEE  RR    RR


*******************************************************************************
*******************************************************************************

                              A Compiler for VSL
                              ==================

   This is the YACC parser. It creates a tree representation of the program for
   subsequent conversion to TAC.

   Modifications:
   ==============

   16 Nov 88 JPB:  First version
   26 Apr 89 JPB:  Version for publication
   27 Jul 89 JPB:  Final version for publication
   15 Sep 92 JPB:  Bug, whereby do_bin overwrote the value of constants less
                   than CONST_MAX when folding is now fixed.
   23 Jan 96 JPB:  Various minor corrections for 2nd edition publication.

*******************************************************************************
******************************************************************************/

%{

/* We include the standard headers, but not "parser.h", since that will be
   produced by YACC when the YACC program is translated. */

#include <stdio.h>
#include <ctype.h>
#include "vc.h"

/* These are the prototypes of routines defined and used in the parser */

TAC   *do_program( TAC *c ) ;
TAC   *do_func( SYMB *func,
              TAC  *args,
              TAC  *code ) ;
TAC   *declare_var( SYMB *var ) ;
TAC   *do_assign( SYMB  *var,
                ENODE *expr ) ;
ENODE *do_bin(  int    binop,
                ENODE *expr1,
                ENODE *expr2 ) ;
ENODE *do_un(  int    unop,
               ENODE *expr ) ;
ENODE *do_fnap( SYMB  *func,
                ENODE *arglist ) ;
TAC   *do_lib( int   rtn,
             SYMB *arg ) ;
TAC   *do_if( ENODE *expr,
            TAC   *stmt ) ;
TAC   *do_test( ENODE *expr,
              TAC   *stmt1,
              TAC   *stmt2 ) ;
TAC   *do_while( ENODE *expr,
               TAC   *stmt ) ;
ENODE *mkenode( ENODE *next,
                SYMB  *res,
                TAC   *code ) ;
void  yyerror( char *str ) ;

/* "program_tac" is the complete TAC recognised by the parser, and set up by
   yyparse, when the sentence symbol, <program>, is recognised. We can't make
   use of "yyval", since that is not exported by the parser if you make use of
   Bison rather than YACC. */

TAC  *program_tac ;                      /* The complete program TAC */

%}

/* %union defines the type of attribute to be synthesised by the semantic
   actions. The variables, constants and text produced by the lexical analyser
   will be symbol table nodes. Most YACC rules will produce lists of TAC,
   however those involving expressions will need to use "enode's" to specify
   where the result of the TAC is put. */

%union
{
        SYMB   *symb ;           /* For vars, consts and text */
        TAC    *tac ;            /* For most things */
        ENODE  *enode ;          /* For expressions */
}

/* Tokens. Most of these don't need types, since they have no associated
   attribute. However variables, integers and text have to have a more complex
   structure, since they return symbol table nodes as attributes. */

%token         FUNC                      /* 'FUNC' */
%token <symb>  VARIABLE                  /* variable name */
%token         ASSIGN_SYMBOL             /* ':=' */
%token <symb>  INTEGER                   /* integer number */
%token         PRINT                     /* 'PRINT' */
%token <symb>  TEXT                      /* quoted text */
%token         RETURN                    /* 'RETURN' */
%token         CONTINUE                  /* 'CONTINUE */
%token         IF                        /* 'IF' */
%token         THEN                      /* 'THEN' */
%token         ELSE                      /* 'ELSE' */
%token         FI                        /* 'FI' */
%token         WHILE                     /* 'WHILE' */
%token         DO                        /* 'DO' */
%token         DONE                      /* 'DONE' */
%token         VAR                       /* 'VAR' */
%token         UMINUS                    /* used for precedence */

/* Now type declarations for the non-terminals. Most non-terminals just return
   a list of TAC as result, however expressions also return a pointer to the
   symbol holding the result of the calculation. */

%type <tac>     program
%type <tac>     function_list
%type <tac>     function
%type <tac>     parameter_list
%type <tac>     variable_list
%type <enode>   argument_list
%type <enode>   expression_list
%type <tac>     statement
%type <tac>     assignment_statement
%type <enode>   expression
%type <tac>     print_statement
%type <tac>     print_list
%type <tac>     print_item
%type <tac>     return_statement
%type <tac>     null_statement
%type <tac>     if_statement
%type <tac>     while_statement
%type <tac>     block
%type <tac>     declaration_list
%type <tac>     declaration
%type <tac>     statement_list
%type <tac>     error

/* We define the precedence of the arithmetic operators, including a
   pseudo-token, "UMINUS" to be used for unary minus when it occurs in
   expressions. */

%left  '+' '-'
%left  '*' '/'
%right UMINUS

%%

/* These are the grammar rules. "program" is the sentence symbol of the
   grammar. It can't just use the default rule to pass back a result, since
   with bison, the result is not put in a variable that is visible externally.
   The solution is to copy the result into the global variable "program_tac"
   for subsequent use. */

program                 :       function_list
                                {
                                        program_tac = $1 ;
                                }
                        ;

/* "function_list" is typical of may rules with two parts. Where we have a
   "function_list" followed by a "function" we call "join_tac()" to combine the
   code for each into one. Note that this use of "join_tac()", involving a walk
   down one of the code lists is very inefficient if the code gets at all
   large. If we intend using VSL for major programs (admittedly unlikely), then
   we should wish to avoid this each time we joined code. We should probably
   chose to use a non-linked TAC representation and place markers as discussed
   in chapter 6. */

function_list           :       function
                        |       function_list function
                                {
                                        $$ = join_tac( $1, $2 ) ;
                                }
                        ;

/* Note that when we start a new "function" we are able to set the temporary
   variable count back to zero, since temporary variable names need only be
   unique within the function where they are declared. Like most rules we call
   a subsidiary routine, "do_func()", to build the code.

   This is one of the places where we attempt rudimentary error recovery. We do
   not specify a synchronising set, but let the parser recover for itself. */

function                :       FUNC VARIABLE '(' parameter_list ')'
                                statement
                                {
                                        $$ = do_func( $2, $4, $6 ) ;
                                }
                        |       error
                                {
                                        error( "Bad function syntax" ) ;
                                        $$ = NULL ;
                                }
                        ;

parameter_list          :       variable_list
                        |
                                {
                                        $$ = NULL ;
                                }
                        ;

variable_list           :       VARIABLE
                                {
                                        $$ = declare_var( $1 ) ;
                                }               
                        |       variable_list ',' VARIABLE
                                {
                                        /* If we get a duplicate declaration,
                                           t will be NULL. join_tac handles
                                           this correctly. */

                                        $$ = join_tac( declare_var( $3 ),
                                                       $1 ) ;
                                }               
                        ;

statement               :       assignment_statement
                        |       return_statement
                        |       print_statement
                        |       null_statement
                        |       if_statement
                        |       while_statement
                        |       block
                        |       error
                                {
                                        error( "Bad statement syntax" ) ;
                                        $$ = NULL ;
                                }
                        ;

assignment_statement    :       VARIABLE ASSIGN_SYMBOL expression
                                {

                                        $$ = do_assign( $1, $3 ) ;
                                }
                        ;

/* Rules for expressions. Note the use of "%prec UMINUS" to define the higher
   precedence of negation. */

expression              :       expression '+' expression
                                {
                                        $$ = do_bin( TAC_ADD, $1, $3 ) ;
                                }
                        |       expression '-' expression
                                {
                                        $$ = do_bin( TAC_SUB, $1, $3 ) ;
                                }
                        |       expression '*' expression
                                {
                                        $$ = do_bin( TAC_MUL, $1, $3 ) ;
                                }
                        |       expression '/' expression
                                {
                                        $$ = do_bin( TAC_DIV, $1, $3 ) ;
                                }
                        |       '-' expression  %prec UMINUS
                                {
                                        $$ = do_un( TAC_NEG, $2 ) ;
                                }
                        |       '(' expression ')'
                                {
                                        $$ = $2 ;
                                }               
                        |       INTEGER
                                {
                                        $$ = mkenode( NULL, $1, NULL ) ;
                                }
                        |       VARIABLE
                                {
                                        /* Check the variable is declared. If
                                           not we subsitute constant zero, or
                                           we get all sorts of problems later
                                           on. */

                                        if( $1->type != T_VAR )
                                        {
                                                error( "Undeclared variable in"
                                                     " expression" ) ;

                                                $$ = mkenode( NULL,
                                                              mkconst( 0 ),
                                                              NULL ) ;
                                        }
                                        else
                                                $$ = mkenode( NULL, $1,
                                                              NULL ) ;
                                }
                        |       VARIABLE '(' argument_list ')'
                                {
                                        $$ = do_fnap( $1, $3 ) ;
                                }               
                        |       error
                                {
                                        error( "Bad expression syntax" ) ;
                                        $$ = mkenode( NULL, NULL, NULL ) ;
                                }
                        ;

argument_list           :
                                {
                                        $$ = NULL ;
                                }
                        |       expression_list
                        ;

expression_list         :       expression
                        |       expression ',' expression_list
                                {

                                        /* Construct a list of expr nodes */

                                        $1->next = $3 ;
                                        $$       = $1 ;
                                }
                        ;

print_statement         :       PRINT print_list
                                {
                                        $$ = $2 ;
                                }               
                        ;

print_list              :       print_item
                        |       print_list ',' print_item
                                {
                                        $$ = join_tac( $1, $3 ) ;
                                }               
                        ;

/* PRINT items are handled by calls to library routines. These take as their
   argument the libary routine to call and the symbol to pass as argument. */

print_item              :       expression
                                {

                                        /* Call printn library routine */

                                        $$ = join_tac( $1->tac,
                                                       do_lib( LIB_PRINTN,
                                                       $1->res )) ;
                                }
                        |       TEXT
                                {

                                        /* Call prints, passing the address of
                                           the string */

                                        $$ = do_lib( LIB_PRINTS, $1 ) ;
                                }
                        ;

return_statement        :       RETURN expression
                                {
                                        TAC *t = mktac( TAC_RETURN, $2->res,
                                                        NULL, NULL ) ;
                                        t->prev = $2->tac ;
                                        free_enode( $2 ) ;
                                        $$      = t ;
                                }               
                        ;

null_statement          :       CONTINUE
                                {
                                        $$ = NULL ;
                                }               
                        ;

/* Note the use of two different routines to handle the different types of IF
   statement. We could have shared this code for conciseness. */

if_statement            :       IF expression THEN statement FI
                                {
                                        $$ = do_if( $2, $4 ) ;
                                }
                        |       IF expression THEN statement
                                ELSE statement FI
                                {
                                        $$ = do_test( $2, $4, $6 ) ;
                                }
                        ;

while_statement         :       WHILE expression DO statement DONE
                                {
                                        $$ = do_while( $2, $4 ) ;
                                }               
                        ;

block                   :       '{' declaration_list statement_list '}'
                                {
                                        $$ = join_tac( $2, $3 ) ;
                                }               
                        ;

declaration_list        :
                                {
                                        $$ = NULL ;
                                }
                        |       declaration_list declaration
                                {
                                        $$ = join_tac( $1, $2 ) ;
                                }
                        ;

declaration             :       VAR variable_list
                                {
                                        $$ = $2 ;
                                }
                        ;

statement_list          :       statement

                        |       statement_list statement
                                {
                                        $$ = join_tac( $1, $2 ) ;
                                }               
                        ;

%%

/* These are the routines to support the various YACC rules. It is invariably
   clearer to put anything but the simplest semantic action in a routine,
   because the layout of YACC bunches code to the right so much. */


TAC *do_func( SYMB *func,                        /* Function */
              TAC  *args,                        /* Its args */
              TAC  *code )                       /* Its code */

/* For a function we must add TAC_BEGINFUNC and TAC_ENDFUNC quadruples
   around it, and a new label at the start. We then enter the name of the
   function in the symbol table. It should not have been declared as a variable
   or function elsewhere, and so should still have type T_UNDEF.

   The function may already be the subject of function calls. The address of
   the quadruples for these calls are held in the LABEL2 field of its symbol
   table entry, ready for backpatching. We run down this list backpatching in
   the address of the starting label, and then replace the field with the
   address of the starting label, also updating the type to T_FUNC.

   Note that there is a fault in the compiler at this point. If we never
   declare a function that is used, then its address will never be backpatched.
   This is a semantic check that needs to be added at the end of parsing. */

{
        TAC *tlist ;                     /* The backpatch list */

        TAC *tlab ;                      /* Label at start of function */
        TAC *tbegin ;                    /* BEGINFUNC marker */
        TAC *tend ;                      /* ENDFUNC marker */

        /* Add this function to the symbol table. If its already there its been
           used before, so backpatch the address into the call opcodes. If
           declared already we have a semantic error and give up. Otherwise
           patch in the addresses and declare as a function */

        if( func->type != T_UNDEF )
        {
                error( "function already declared" ) ;
                return NULL ;
        }

        tlab   = mktac( TAC_LABEL,     mklabel( next_label++ ), NULL, NULL ) ;
        tbegin = mktac( TAC_BEGINFUNC, NULL, NULL, NULL ) ;
        tend   = mktac( TAC_ENDFUNC,   NULL, NULL, NULL ) ;

        tbegin->prev = tlab ;
        code         = join_tac( args, code ) ;
        tend->prev   = join_tac( tbegin, code ) ;

        tlist = func->LABEL2 ;                   /* List of addresses if any */

        while( tlist != NULL )
        {
                TAC *tnext = tlist->LB ;         /* Next on list */

                tlist->LB  = tlab ;
                tlist      = tnext ;
        }

        func->type   = T_FUNC ;          /* And declare as func */
        func->LABEL2 = tlab ;

        return tend ;

}       /* TAC *do_func( SYMB *func,
                         TAC  *args,
                         TAC  *code ) */


TAC *declare_var( SYMB *var )

/* All variable names may be used only once throughout a program. We check here
   that they have not yet been declared and if so declare them, setting their
   stack offset to -1 (an invalid offset) and marking their address descriptor
   empty. Note that this is a fault in the compiler. We really do need to mark
   the beginning and end of blocks in which variables are declared, so that
   scope can be checked. */

{
        if( var->type != T_UNDEF )
        {
                error( "variable already declared" ) ;
                return NULL ;
        }

        var->type  = T_VAR ;
        var->ADDR2 = -1 ;                /* Unset address */

        /* TAC for a declaration */

        return  mktac( TAC_VAR, var, NULL, NULL ) ;

}       /* TAC *declare_var( SYMB *var ) */


TAC *do_assign( SYMB  *var,      /* Variable to be assigned */
                ENODE *expr )    /* Expression to assign */

/* An assignment statement shows the use of expression nodes. We construct a
   copy node to take the result of the expression and copy it into the
   variable, having performed suitable semantic checks. Note that if we
   discover that the variable has not been declared, we declare it, to prevent
   further non-declaration errors each time it is referenced. */

{
        TAC  *code ;

        /* Warn if variable not declared, then build code */

        if( var->type != T_VAR )
                error( "assignment to non-variable" ) ;

        code       = mktac( TAC_COPY, var, expr->res, NULL ) ;
        code->prev = expr->tac ;
        free_enode( expr ) ;             /* Expression now finished with */

        return code ;

}       /* TAC *do_assign( SYMB  *var,
                           ENODE *expr ) */


ENODE *do_bin(  int    binop,            /* TAC binary operator */
                ENODE *expr1,            /* Expressions to operate on */
                ENODE *expr2 )

/* We then have the first of the arithmetic routines to handles binary
   operators.  We carry out one of the few optimisations in the compiler here,
   constant folding. We might think of reusing one of the expression nodes for
   efficiency. However because constants up to CONST_MAX are held in shared
   symbols, we risk altering the value of such constants in future use. For
   simplicity we just create a new constant node for the result, rather than
   sorting out if we can reuse the node. If we can't do folding we generate the
   result into a temporary variable, which we first declare, returning an
   expression node for the TAC with the temporary in the result field. */

{
        TAC  *temp ;                     /* TAC code for temp symbol */
        TAC  *res ;                      /* TAC code for result */

        /* Do constant folding if possible. Calculate the constant into newval
           and make a new constant node for the result. Free up expr2. */

        if(( expr1->ETYPE == T_INT ) && ( expr2->ETYPE == T_INT ))
        {
                int   newval;            /* The result of constant folding */

                switch( binop )          /* Chose the operator */
                {
                case TAC_ADD:

                        newval = expr1->EVAL1 + expr2->EVAL1 ;
                        break ;

                case TAC_SUB:

                        newval = expr1->EVAL1 - expr2->EVAL1 ;
                        break ;

                case TAC_MUL:

                        newval = expr1->EVAL1 * expr2->EVAL1 ;
                        break ;

                case TAC_DIV:

                        newval = expr1->EVAL1 / expr2->EVAL1 ;
                        break ;
                }

                expr1->res = mkconst(newval);  /* New space for result */
                free_enode( expr2 ) ;          /* Release space in expr2 */

                return expr1 ;             /* The new expression */
        }

        /* Not constant, so create a TAC node for a binary operator, putting
           the result in a temporary. Bolt the code together, reusing expr1 and
           freeing expr2. */

        temp       = mktac( TAC_VAR, mktmp(), NULL, NULL ) ;
        temp->prev = join_tac( expr1->tac, expr2->tac ) ;
        res        = mktac( binop, temp->VA, expr1->res, expr2->res ) ;
        res->prev  = temp ;

        expr1->res = temp->VA ;
        expr1->tac = res ;
        free_enode( expr2 ) ;

        return expr1 ;  

}       /* ENODE *do_bin(  int    binop,
                           ENODE *expr1,
                           ENODE *expr2 ) */


ENODE *do_un(  int    unop,              /* TAC unary operator */
               ENODE *expr )             /* Expression to operate on */

/* This is an analagous routine to deal with unary operators. In the interests
   of generality it has been written to permit easy addition of new unary
   operators, although there is only one at present. */


{
        TAC  *temp ;                     /* TAC code for temp symbol */
        TAC  *res ;                      /* TAC code for result */

        /* Do constant folding if possible. Calculate the constant into expr */

        if( expr->ETYPE == T_INT )
        {
                switch( unop )           /* Chose the operator */
                {
                case TAC_NEG:

                        expr->EVAL1 = - expr->EVAL1 ;
                        break ;
                }

                return expr ;              /* The new expression */
        }

        /* Not constant, so create a TAC node for a unary operator, putting
           the result in a temporary. Bolt the code together, reusing expr. */

        temp       = mktac( TAC_VAR, mktmp(), NULL, NULL ) ;
        temp->prev = expr->tac ;
        res        = mktac( unop, temp->VA, NULL, expr->res ) ;
        res->prev  = temp ;

        expr->res = temp->VA ;
        expr->tac = res ;

        return expr ;   

}       /* ENODE *do_un(  int    unop,
                          ENODE *expr ) */


ENODE *do_fnap( SYMB  *func,             /* Function to call */
                ENODE *arglist )         /* Its argument list */

/* Construct a function call to the given function. If the function is not yet
   defined, then we must add this call to the backpatching list. Return the
   result of the function in a temporary. Note the qualication about
   backpatching above in the definition of "do_func()"

   When constructing a function call we put the result in a temporary. We join
   all the TAC for the expressions first, then join the code for the TAC_ARG
   instructions, since arg instructions must appear consecutively. */

{
        ENODE  *alt ;                    /* For counting args */
        SYMB   *res ;                    /* Where function result will go */
        TAC    *code ;                   /* Resulting code */
        TAC    *temp ;                   /* Temporary for building code */

        /* Check that this is a valid function. In this case it must either be
           T_UNDEF or T_FUNC. If it is declare the result, run down the
           argument list, joining up the code for each argument, then generate
           a sequence of arg instructions and finally a call instruction */

        if(( func->type != T_UNDEF ) && ( func->type != T_FUNC ))
        {
                error( "function declared other than function" );
                return NULL ;
        }

        res   = mktmp() ;                            /* For the result */
        code  = mktac( TAC_VAR, res, NULL, NULL ) ;

        for( alt = arglist ; alt != NULL ; alt = alt->next )  /* Join args */
                code = join_tac( code, alt->tac ) ;

        while( arglist != NULL )         /* Generate ARG instructions */
        {
                temp       = mktac( TAC_ARG, arglist->res, NULL, NULL ) ;
                temp->prev = code ;
                code       = temp ;

                alt = arglist->next ;
                free_enode( arglist ) ;  /* Free the space */
                arglist = alt ;
        } ;

        temp       = mktac( TAC_CALL, res, (SYMB *)func->LABEL2, NULL ) ;
        temp->prev = code ;
        code       = temp ;

        /* If the function is undefined update its backpatching list with the
           address of this instruction and then return an expression node for
           the result */

        if( func->type == T_UNDEF )
                func->LABEL2 = code ;

        return mkenode( NULL, res, code ) ;

}       /* ENODE *do_fnap( SYMB  *func,
                           ENODE *arglist ) */


TAC *do_lib( int   rtn,                  /* Routine to call */
             SYMB *arg )                 /* Argument to pass */

/* PRINT items are handled by calls to library routines. These take as their
   argument the libary routine to call and the symbol to pass as argument.
   This routine constructs a call to a libary routine with a single argument.
*/

{
        TAC *a = mktac( TAC_ARG, arg, NULL, NULL ) ;
        TAC *c = mktac( TAC_CALL, NULL, (SYMB *)library[rtn], NULL ) ;

        c->prev = a ;

        return c ;

}       /* TAC *do_lib( int   rtn,
                        SYMB *arg ) */


TAC *do_if( ENODE *expr,                 /* Condition */
            TAC   *stmt )                /* Statement to execute */

/* For convenience we have two routines to handle IF statements, "do_if()"
   where there is no ELSE part and "do_test()" where there is. We always
   allocate TAC_LABEL instructions, so that the destinations of all branches
   will appear as labels in the resulting TAC code. */

{
        TAC *label = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
        TAC *code  = mktac( TAC_IFZ, (SYMB *)label, expr->res, NULL ) ;

        code->prev  = expr->tac ;
        code        = join_tac( code, stmt ) ;
        label->prev = code ;

        free_enode( expr ) ;             /* Expression finished with */

        return label ;

}       /* TAC *do_if( ENODE *expr,
                       TAC   *stmt ) */


TAC *do_test( ENODE *expr,               /* Condition */
              TAC   *stmt1,              /* THEN part */
              TAC   *stmt2 )             /* ELSE part */

/* Construct code for an if statement with else part */

{
        TAC *label1 = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
        TAC *label2 = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
        TAC *code1  = mktac( TAC_IFZ, (SYMB *)label1, expr->res, NULL ) ;
        TAC *code2  = mktac( TAC_GOTO, (SYMB *)label2, NULL, NULL ) ;

        code1->prev  = expr->tac ;                      /* Join the code */
        code1        = join_tac( code1, stmt1 ) ;
        code2->prev  = code1 ;
        label1->prev = code2 ;
        label1       = join_tac( label1, stmt2 ) ;
        label2->prev = label1 ;

        free_enode( expr ) ;             /* Free the expression */

        return label2 ;

}       /* TAC *do_test( ENODE *expr,
                         TAC   *stmt1,
                         TAC   *stmt2 ) */


TAC *do_while( ENODE *expr,              /* Condition */
               TAC   *stmt )             /* Body of loop */

/* Do a WHILE loop. This is the same as an IF statement with a jump back at the
   end. We bolt a goto on the end of the statement, call do_if to construct the
   code and join the start label right at the beginning */

{
        TAC *label = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
        TAC *code  = mktac( TAC_GOTO, (SYMB *)label, NULL, NULL ) ;

        code->prev = stmt ;              /* Bolt on the goto */

        return join_tac( label, do_if( expr, code )) ;

}       /* TAC *do_while( ENODE *expr,
                          TAC   *stmt ) */


ENODE *mkenode( ENODE *next,
                SYMB  *res,
                TAC   *code )

/* The routine to make an expression node. We put this here rather than with
   the other utilities in "main.c", since it is only used in the parser. */

{
        ENODE *expr = get_enode() ;

        expr->next = next ;
        expr->res  = res ;
        expr->tac  = code ;

        return expr ;

}       /* ENODE *mkenode( ENODE *next,
                           SYMB  *res,
                           TAC   *code ) */


void  yyerror( char *str )

/* The Yacc default error handler. This just calls our error handler */

{
        error( str ) ;

}       /* void  yyerror( char *str ) */
