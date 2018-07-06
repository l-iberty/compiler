/******************************************************************************
*******************************************************************************


                                CCCCC    GGGGGG 
                               CCCCCCC  GGGGGGGG
                              CC        GG      
                              CC        GG  GGGG
                              CC        GG    GG
                              CC        GG    GG
                               CCCCCCC  GGGGGGGG
                                CCCCC    GGGGGG 


*******************************************************************************
*******************************************************************************

                              A Compiler for VSL
                              ==================

   This is the code generator section

   Modifications:
   ==============

   22 Nov 88 JPB:  First version
   26 Apr 89 JPB:  Version for publication
    1 Aug 89 JPB:  Final version for publication
   13 Jun 90 JPB:  Now refers to library directory (noted by R C Shaw, Praxis).
    9 May 91 JPB:  load_reg call in cg_cond removed to avoid conflict (J
                   Johnson)
   23 Jan 96 JPB:  Various minor corrections for 2nd edition publication.

*******************************************************************************
******************************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "vc.h"

/* Constants used here. First we define some of the registers. We reserve
   register R1 as the stack pointer and use registers R2 - R4 in the calling
   and return sequences. */

#define R_ZERO          0                /* Constant zero */
#define R_P             1                /* Stack pointer */
#define R_CALL          2                /* Address of called routine */
#define R_RET           3                /* Return address */
#define R_RES           4                /* Result reg and last reserved */
#define R_GEN           5                /* First general purpose register */
#define R_MAX          16                /* 16 regs */

/* The stack frame holds the dynamic link at offset zero and the return address
   at offset 4. */

#define P_OFF           0                /* Offset of stack pointer on frame */
#define PC_OFF          4                /* Offset of ret address on frame */
#define VAR_OFF         8                /* Offset of variables on frame */

/* To make the code clearer we define flags MODIFIED and UNMODIFIED as TRUE and
   FALSE respectively for setting the mod field of the register descriptor. */

#define MODIFIED     TRUE                /* Entries for descriptors */
#define UNMODIFIED  FALSE

/* These are static variables used throughout this section. The register
   descriptor is an array of anonymous structures with a field to hold the most
   recent item slaved in the register and a field to mark whether the register
   has been modified since last written to memory.

   "tos" is the top of stack in the current function and "next_arg" is the
   number of the next argument to load on the stack. */

struct                                   /* Reg descriptor */
{
        struct symb *name ;              /* Thing in reg */
        int          modified ;          /* If needs spilling */
}    rdesc[R_MAX] ;
int  tos ;                               /* Top of stack */
int  next_arg ;                          /* Next argument to load */

/* These are the prototypes of routines defined here. Routines to translate TAC
   instructions generally have the form "cg_xxx()" where xxx is the name of a
   TAC instruction of group of TAC instructions. */

void  cg( TAC *tl ) ;
TAC  *init_cg( TAC *tl ) ;
void  cg_instr( TAC *c ) ;
void  cg_bin( char *op,
              SYMB *a,
              SYMB *b,
              SYMB *c ) ;
void  cg_copy( SYMB *a,
               SYMB *b ) ;
void  cg_cond( char *op,
               SYMB *a,
               int   l ) ;
void  cg_arg( SYMB *a ) ;
void  cg_call( int   f,
               SYMB *res ) ;
void  cg_return( SYMB *a ) ;
void  cg_sys( char *fn ) ;
void  cg_strings( void ) ;
void  cg_str( SYMB *s ) ;
void  flush_all( void ) ;
void  spill_all( void ) ;
void  spill_one( int  r ) ;
void  load_reg( int   r,
                SYMB *n ) ;
void  clear_desc( int   r ) ;
void  insert_desc( int   r,
                   SYMB *n,
                   int   mod ) ;
int   get_rreg( SYMB *c ) ;
int   get_areg( SYMB *b,
               int   cr ) ;


void  cg( TAC *tl )

/* The code generator is initialised by "cg_init()", finding the start of the
   TAC list in the process (since the syntax analysis phase has given us the
   end of the list, and the code generator works from the start of the list).

   We first copy a header file to the output containing initialisation code and
   then loop generating code for each TAC instruction. The code is preceded by
   a comment line in the assembler giving the TAC instruction being translated.
   After generating code for the TAC, we copy the library file and then
   generate code for all the text strings used in the program.

   Note that in the book the header and lib files are just referred to as
   "header" and "lib", thus assuming that they will be in the same directory
   that the compiler is run in. We have included a #defined library path here
   for greater flexibility. */

{
        TAC *tls = init_cg( tl ) ;              /* Start of TAC */

        cg_sys( LIB_DIR "header" ) ;             /* Standard header */

        for( ; tls != NULL ; tls = tls->next )  /* Instructions in turn */
        {
                printf( "\\ " ) ;
                print_instr( tls ) ;
                cg_instr( tls ) ;
        }

        cg_sys( LIB_DIR "lib" ) ;                /* Library */
        cg_strings() ;                           /* String data */

}       /* void  cg( TAC *tl ) */


TAC *init_cg( TAC *tl )

/* Initialisation involves clearing the register descriptors (apart from zero
   in R0), setting the top of stack and next_arg indices and clearing the free
   lists for address and register descriptors. We finally find the end of the
   TAC list, setting .cb next fields in the TAC as we do so. */

{
        int  r ;
        TAC *c ;                         /* Current TAC instruction */
        TAC *p ;                         /* Previous TAC instruction */

        for( r = 0 ; r < R_MAX ; r++ )
                rdesc[r].name = NULL ;

        insert_desc( 0, mkconst( 0 ), UNMODIFIED ) ;     /* R0 holds 0 */

        tos      = VAR_OFF ;             /* TOS allows space for link info */
        next_arg = 0 ;                   /* Next arg to load */

        /* Tidy up and reverse the code list */

        c = NULL ;                       /* No current */
        p = tl ;                         /* Preceding to do */

        while( p != NULL )
        {
                p->next = c ;            /* Set the next field */
                c       = p ;            /* Step on */
                p       = p->prev ;
        }

        return c ;

}       /* TAC *init_cg( TAC *tl ) */


void  cg_instr( TAC *c )

/* Generate code for a single TAC instruction. This is just a switch on all
   possible TAC instructions. Hopefully if we have written the front end
   correctly the default case will never be encountered. For most cases we just
   call a subsidiary routine "cg_xxx()" to do the code generation. */

{
        switch( c->op )
        {
        case TAC_UNDEF:

                error( "cannot translate TAC_UNDEF" ) ;
                return ;

        case TAC_ADD:

                cg_bin( "ADD", c->VA, c->VB, c->VC ) ;
                return ;

        case TAC_SUB:

                cg_bin( "SUB", c->VA, c->VB, c->VC ) ;
                return ;

        case TAC_MUL:

                cg_bin( "MUL", c->VA, c->VB, c->VC ) ;
                return ;

        case TAC_DIV:

                cg_bin( "DIV", c->VA, c->VB, c->VC ) ;
                return ;

        case TAC_NEG:

                cg_bin( "SUB", c->VA, mkconst( 0 ), c->VB ) ;
                return ;

        case TAC_COPY:

                cg_copy( c->VA, c->VB ) ;
                return ;

        case TAC_GOTO:

                cg_cond( "BRA", NULL, c->LA->VA->VAL1 ) ;
                return ;

        case TAC_IFZ:

                cg_cond( "BZE", c->VB, c->LA->VA->VAL1 ) ;
                return ;

        case TAC_IFNZ:

                cg_cond( "BNZ", c->VB, c->LA->VA->VAL1 ) ;
                return ;

        case TAC_ARG:

                cg_arg( c->VA ) ;
                return ;

        case TAC_CALL:

                cg_call( c->LB->VA->VAL1, c->VA ) ;
                return ;

        case TAC_RETURN:

                cg_return( c->VA ) ;
                return ;

        case TAC_LABEL:

                /* We generate an appropriate label. Note that we must flush
                   the register descriptor, since control may arrive at this
                   label from other points in the code. */

                flush_all() ;
                printf( "L%u:\n", c->VA->VAL1 ) ;
                return ;

        case TAC_VAR:

                /* Allocate 4 bytes for this variable to hold an integer on the
                   current top of stack */

                c->VA->ADDR2 = tos ;
                tos += 4 ;
                return ;

        case TAC_BEGINFUNC:

                /* At the start of a function we must copy the return address
                   which will be in R_RET onto the stack. We reset the top of
                   stack, since it is currently empty apart from the link
                   information. */

                tos = VAR_OFF ;
                printf( "       STI  R%u,%u(R%u)\n", R_RET, PC_OFF, R_P ) ;
                return ;

        case TAC_ENDFUNC:

                /* At the end of the function we put in an implicit return
                   instruction. */

                cg_return( NULL ) ;
                return ;

        default:

                /* Don't know what this one is */

                error( "unknown TAC opcode to translate" ) ;
                return ;
        }

}       /* void  cg_instr( TAC *c ) */


void  cg_bin( char *op,                  /* Opcode to use */
              SYMB *a,                   /* Result */
              SYMB *b,                   /* Operands */
              SYMB *c )

/* Generate code for a binary operator

      a := b op c

   VAM has 2 address opcodes with the result going into the second operand

   This is a typical code generation functions. We find and load a separate
   register for each argument, the second argument also being used for the
   result. We then generate the code for binary operator, updating the register
   descriptor appropriately. */

{
        int  cr = get_rreg( c ) ;        /* Result register */
        int  br = get_areg( b, cr ) ;    /* Second argument register */

        printf( "       %s  R%u,R%u\n", op, br, cr ) ;

        /* Delete c from the descriptors and insert a */

        clear_desc( cr ) ;
        insert_desc( cr, a, MODIFIED ) ;

}       /* void  cg_bin( char *op,
                         SYMB *a,
                         SYMB *b,
                         SYMB *c ) */


void  cg_copy( SYMB *a,
               SYMB *b )

/* Generate code for a copy instruction

      a := b

   We load b into an register, then update the descriptors to indicate that a
   is also in that register. We need not do the store until the register is
   spilled or flushed. */

{
        int  br = get_rreg( b ) ;        /* Load b into a register */

        insert_desc( br, a, MODIFIED ) ; /* Indicate a is there */

}       /* void  cg_copy( SYMB *a,
                          SYMB *b ) */


void  cg_cond( char *op,
               SYMB *a,                  /* Condition */
               int   l )                 /* Branch destination */

/* Generate for "goto", "ifz" or "ifnz". We must spill registers before the
   branch. In the case of unconditional goto we have no condition, and so "b"
   is NULL. We set the condition flags if necessary by explicitly loading "a"
   into a register to ensure the zero flag is set. A better approach would be
   to keep track of what is in the status register, so saving this load. */

{
        spill_all() ;

        if( a != NULL )
        {
                int  r ;

                for( r = R_GEN ; r < R_MAX ; r++ )   /* Is it in reg? */
                        if( rdesc[r].name == a )
                                break ;

                /* Bug fix 3/5/91 to reload into the existing register
                   correctly. */

                if( r < R_MAX )

                        /* Reload into existing reg. Don't use load_reg, since
                           it updates rdesc */

                        printf( "       LDR  R%u,R%u\n", r, r ) ;
                else
                        (void)get_rreg( a ) ;  /* Load into new register */
        }

        printf( "       %s  L%u\n", op, l ) ;   /* Branch */

}       /* void  cg_cond( char *op,
                          SYMB *a,
                          int   l ) */


void  cg_arg( SYMB *a )

/* Generate for an ARG instruction. We load the argument into a register, and
   then write it onto the new stack frame, which is 2 words past the current
   top of stack. We keep track of which arg this is in the global variable
   "next_arg". We assume that ARG instructions are always followed by other ARG
   instructions or CALL instructions. */

{
        int  r  = get_rreg( a ) ;

        printf( "       STI  R%u,%u(R%u)\n", r, tos + VAR_OFF + next_arg,
                R_P ) ;
        next_arg += 4 ;

}       /* void  cg_arg( SYMB *a ) */


void  cg_call( int   f,
               SYMB *res )

/* The standard call sequence is

      LDA  f(R0),R2
      STI  R1,tos(R1)
      LDA  tos(R1),R1
      BAL  R2,R3
    ( STI  R4,res )

   We flush out the registers prior to a call and then execute the standard
   CALL sequence. Flushing involves spilling modified registers, and then
   clearing the register descriptors. We use BAL to do the call, which means
   R_RET will hold the return address on entry to the function which must be
   saved on the stack. After the call if there is a result it will be in R_RES
   so enter this in the descriptors.  We reset "next_arg" before the call,
   since we know we have finished all the arguments now. */

{
        flush_all() ;
        next_arg = 0 ;
        printf( "       LDA  L%u,R%u\n", f, R_CALL ) ;
        printf( "       STI  R%u,%u(R%u)\n", R_P, tos, R_P ) ;
        printf( "       LDA  %u(R%u),R%u\n", tos, R_P, R_P ) ;
        printf( "       BAL  R%u,R%u\n", R_CALL, R_RET ) ;

        if( res != NULL )                     /* Do a result if there is one */
                insert_desc( R_RES, res, MODIFIED ) ;

}       /* void  cg_call( int   f,
                          SYMB *res ) */


void  cg_return( SYMB *a )

/* The standard return sequence is

    ( LDI  a,R4 )
      LDI  4(R1),R2    return program counter
      LDI  0(R1),R1    return stack pointer
      BAL  R2,R3

   If "a" is NULL we don't load anything into the result register.
*/

{
        if( a != NULL )
        {
                spill_one( R_RES ) ;
                load_reg( R_RES, a ) ;
        }

        printf( "       LDI  %u(R%u),R%u\n", PC_OFF, R_P, R_CALL ) ;    
        printf( "       LDI  %u(R%u),R%u\n", P_OFF, R_P, R_P ) ;        
        printf( "       BAL  R%u,R%u\n", R_CALL, R_RET ) ;      

}       /* void  cg_return( SYMB *a ) */


void  cg_sys( char *fn )                 /* File name */

/* This routine is used to copy standard header and library files into the
   generated code. */

{
/*printf("system file = %s\n", fn);*/
        FILE *fd = fopen( fn, "r" ) ; /* The library file */
        int  c ;

        if( fd == NULL )
        {
                error( "cannot open system file" ) ;
                error(  fn ) ;
                exit( 0 ) ;
        }

        while((c = getc( fd )) != EOF )
                putchar( c ) ;

        fclose( fd ) ;

}       /* void  cg_sys( char *fn ) */


void  cg_strings( void )

/* This routine runs through the symbol table at the end of code generation to
   find all the strings, calling "cg_str()" to generate each string as a series
   of bytes declarations. It finally generates label zero to mark the end of
   code. */

{
        int  i ;

        for( i = 0 ; i < HASHSIZE ; i++)   /* Find all symbol table chains */
        {
                SYMB *sl ;

                for( sl = symbtab[i] ; sl != NULL ; sl = sl->next )
                        if( sl->type == T_TEXT )
                                cg_str( sl ) ;
        }

        printf( "L0:\n" ) ;

}       /* void  cg_strings( void ) */


void  cg_str( SYMB *s )

/* Generate bytes for this string. Ignore the quotes and translate escapes */

{
        char *t = s->TEXT1 ;             /* The text */
        int   i ;

        printf( "L%u:\n", s->VAL2 ) ;    /* Label for the string */

        for( i = 1 ; t[i + 1] != EOS ; i++ )
                if( t[i] == '\\' )
                        switch( t[++i] )
                        {
                                case 'n':

                                        printf( "       DB   %u\n", '\n' ) ;
                                        break ;

                                case '\"':

                                        printf( "       DB   %u\n", '\"' ) ;
                                        break ;
                        }
                else
                        printf( "       DB   %u\n", t[i] ) ;

        printf( "       DB   0\n" ) ;    /* End of string */

}       /* void  cg_str( SYMB *s ) */


/* These are the support routines for the code generation. "flush_all()' is
   used to write all modified registers and clear the registers at points where
   their validity can not be guaranteed (after labels and function calls).
   "spill_all()" is used to write all modified registers at points where we
   wish memory to be consistent (prior to a branch).  "spill_one()" is used to
   write a specific register out if it is modified. */


void  flush_all( void )

/* Spill all registers, and clear their descriptors. Although we don't spill
   the result register (it is only set on a return, and therefore never needs
   saving for future use), we do clear its descriptor! */

{
        int  r ;

        spill_all() ;

        for( r = R_GEN ; r < R_MAX ; r++ )   /* Clear the descriptors */
                clear_desc( r ) ;

        clear_desc( R_RES ) ;                /* Clear result register */

}       /* void  flush_all( void ) */


void  spill_all( void )

/* Spill all the registers */

{
        int  r ;

        for( r = R_GEN ; r < R_MAX ; r++ )
                spill_one( r ) ;

}       /* spill_all( void ) */


void  spill_one( int  r )

/* Spill the value in register r if there is one and it's modifed */

{
        if( (rdesc[r].name != NULL) && rdesc[r].modified )
        {
                printf( "       STI  R%u,%u(R%u)\n", r, rdesc[r].name->ADDR2,
                        R_P ) ;
                rdesc[r].modified = UNMODIFIED ;
        }

}       /* void  spill_one( int  r ) */


void  load_reg( int   r,                 /* Register to be loaded */
                SYMB *n )                /* Name to load */

/* "load_reg()" loads a value into a register. If the value is in a different
   register it uses LDR. If it is a constant it uses LDA indexed off R0 and if
   a piece of text, the address of the text is loaded with LDA. Variables are
   loaded from the stack with LDI.

   We update the register descriptor accordingly */

{
        int  s ;

        /* Look for a register */

        for( s = 0 ; s < R_MAX ; s++ )  
                if( rdesc[s].name == n )
                {
                        printf( "       LDR  R%u,R%u\n", s, r ) ;
                        insert_desc( r, n, rdesc[s].modified ) ;
                        return ;
                }

        /* Not in a reg. Load appropriately */

        switch( n->type )
        {
        case T_INT:

                printf( "       LDA  %u(R0),R%u\n", n->VAL1, r ) ;
                break ;

        case T_VAR:

                printf( "       LDI  %u(R%u),R%u\n", n->ADDR2, R_P, r ) ;
                break ;

        case T_TEXT:

                printf( "       LDA  L%u,R%u\n", n->VAL2, r ) ;
                break ;
        }

        insert_desc( r, n, UNMODIFIED ) ;

}       /* void  load_reg( int   r,
                           SYMB *n ) */


/* We have three routines to handle the register descriptor. "clear_desc()"
   removes any slave information in a register, "insert_desc()" inserts slave
   information. */


void  clear_desc( int   r )              /* Register to delete */

/* Clear the descriptor for register r */

{
        rdesc[r].name = NULL ;

}       /* void  clear_desc( int   r ) */


void  insert_desc( int   r,
                   SYMB *n,
                   int   mod )

/* Insert a descriptor entry for the given name. First as a precaution delete
   it from any existing descriptor. */

{
        int  or ;                       /* Old register counter */

        /* Search through each register in turn looking for "n". There should
           be at most one of these. */

        for( or = R_GEN ; or < R_MAX ; or++ )
        {
                if( rdesc[or].name == n )
                {
                        /* Found it, clear it and break out of the loop. */

                        clear_desc( or ) ;
                        break ;
                }
        }

        /* We should not find any duplicates, but check, just in case. */

        for( or++ ; or < R_MAX ; or++ )
        
                if( rdesc[or].name == n )
                {
                        error( "Duplicate slave found" ) ;
                        clear_desc( or ) ;
                }

        /* Finally insert the name in the new descriptor */

        rdesc[r].name     = n ;
        rdesc[r].modified = mod ;

}       /* void  insert_desc( int   r,
                              SYMB *n,
                              int   mod ) */


/* These two routines implement the simple register allocation algorithm
   described in chapter 10. "get_rreg()" gets a register that will hold an
   operand and be overwritten by a result. "get_areg()" gets a register that
   will hold an operand that will no be overwritten. */


int  get_rreg( SYMB *c )

/* Get a register to hold the result of the computation

      a := b op c

   This must initially hold c and will be overwritten with a. If c is already
   in a register we use that, spilling it first if necessary, otherwise we
   chose in order of preference from

      An empty register
      An unmodified register
      A modified register

   In the last case we spill the contents of the register before it is used. If
   c is not in the given result register we load it. Clearly we cannot use R0
   for this purpose, even if c is constant zero. We also avoid using the
   reserved registers. Note that since c may be the same as b we must update
   the address and register descriptors. */ 

{
        int        r ;                   /* Register for counting */

        for( r = R_GEN ; r < R_MAX ; r++ )   /* Already in a register */
                if( rdesc[r].name == c )
                {
                        spill_one( r ) ;
                        return r ;
                }

        for( r = R_GEN ; r < R_MAX ; r++ )
                if( rdesc[r].name == NULL )  /* Empty register */
                {
                        load_reg( r, c ) ;
                        return r ;
                }

        for( r = R_GEN ; r < R_MAX ; r++ )
                if( !rdesc[r].modified )     /* Unmodifed register */
                {
                        clear_desc( r ) ;
                        load_reg( r, c ) ;
                        return r ;
                }

        spill_one( R_GEN ) ;                 /* Modified register */
        clear_desc( R_GEN ) ;
        load_reg( R_GEN, c ) ;
        return R_GEN ;

}       /* int  get_rreg( SYMB *c ) */


int  get_areg( SYMB *b,
               int   cr )                /* Register already holding b */

/* Get a register to hold the second argument of the computation

      a := b op c

   This must hold b and will not be overwritten. If b is already in a register
   we use that, otherwise we chose in order of preference from 

      An empty register
      An unmodified register
      A modified register

   In the last case we spill the contents of the register before it is used. If
   b is not in the given argument register we load it. We can use R0 for this
   purpose, even if b is constant zero, but we avoid using the reserved
   registers. We may not use cr unless it already contains b. */

{
        int        r ;                   /* Register for counting */

        for( r = R_ZERO ; r < R_MAX ; r++ )
                if( rdesc[r].name == b )              /* Already in register */
                        return r ;

        for( r = R_GEN ; r < R_MAX ; r++ )
                if( rdesc[r].name == NULL )           /* Empty register */
                {
                        load_reg( r, b ) ;
                        return r ;
                }

        for( r = R_GEN ; r < R_MAX ; r++ )
                if( !rdesc[r].modified && (r != cr))  /* Unmodifed register */
                {
                        clear_desc( r ) ;
                        load_reg( r, b ) ;
                        return r ;
                }

        for( r = R_GEN ; r < R_MAX ; r++ )
                if( r != cr )                          /* Modified register */
                {
                        spill_one( r ) ;
                        clear_desc( r ) ;
                        load_reg( r, b ) ;
                        return r ;
                }

}       /* int  get_areg( SYMB *b,
                          int   cr ) */
