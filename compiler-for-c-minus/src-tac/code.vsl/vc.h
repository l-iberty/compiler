/******************************************************************************
*******************************************************************************


          HH    HH  EEEEEEEE    AAAA    DDDDDD    EEEEEEEE  RRRRRRR 
          HH    HH  EEEEEEEE   AAAAAA   DDDDDDD   EEEEEEEE  RRRRRRRR
          HH    HH  EE        AA    AA  DD    DD  EE        RR    RR
          HHHHHHHH  EEEEEE    AAAAAAAA  DD    DD  EEEEEE    RRRRRRRR
          HH    HH  EE        AA    AA  DD    DD  EE        RRRRRRR 
          HH    HH  EE        AA    AA  DD    DD  EE        RR  RR  
          HH    HH  EEEEEEEE  AA    AA  DDDDDDD   EEEEEEEE  RR   RR 
          HH    HH  EEEEEEEE  AA    AA  DDDDDD    EEEEEEEE  RR    RR


*******************************************************************************
*******************************************************************************

                              A Compiler for VSL
                              ==================

   This is the general header file.

   Modifications:
   ==============

   22 Nov 88 JPB:  First version
   26 Apr 89 JPB:  Version for publication
   13 Jun 90 JPB:  Now refers to library directory (noted by R C Shaw, Praxis).
   23 Jan 96 JPB:  Various minor corrections for 2nd edition publication.

*******************************************************************************
******************************************************************************/

/* We start by defining the various constants used throughout the compiler. */

#define TRUE        1                    /* Booleans */
#define FALSE       0
#define EOS         0                    /* End of string */
#define HASHSIZE  997                    /* Size of symbol table */
#define R_UNDEF    -1                    /* Not a valid register */

/* We define the various symbol types permitted. Note the use of T_UNDEF Many
   names are entered into the symbol table by the lexical analyser before their
   type is known, and so we given them an undefined type. */

#define  T_UNDEF  0                      /* Types for symbol table */
#define  T_VAR    1                      /* Local Variable */
#define  T_FUNC   2                      /* Function */
#define  T_TEXT   3                      /* Static string */
#define  T_INT    4                      /* Integer constant */
#define  T_LABEL  5                      /* TAC label */

/* We define constants for each of the three address code (TAC) instructions.
   For convenience we have an undefined instruction, then we specify the 12
   main TAC opcodes. */ 

#define  TAC_UNDEF    0                  /* TAC instructions */
#define  TAC_ADD      1                  /* a := b + c */
#define  TAC_SUB      2                  /* a := b - c */
#define  TAC_MUL      3                  /* a := b * c */
#define  TAC_DIV      4                  /* a := b / c */
#define  TAC_NEG      5                  /* a := -b */
#define  TAC_COPY     6                  /* a := b */
#define  TAC_GOTO     7                  /* goto a */
#define  TAC_IFZ      8                  /* ifz b goto a */
#define  TAC_IFNZ     9                  /* ifnz b goto a */
#define  TAC_ARG     10                  /* arg a */
#define  TAC_CALL    11                  /* a := call b */
#define  TAC_RETURN  12                  /* return a */

/* We then add some extra "pseudo-instructions" to mark places in the code.
   TAC_LABEL s used to mark branch targets. Its first argument will be a symbol
   table entry for a label giving a unique number for this label. TAC_VAR
   is associated with variable declarations, to help in assigning stack
   locations. TAC_BEGINFUNC and TAC_ENDFUNC mark the beginning and end of
   functions respectively. */

#define  TAC_LABEL       13              /* Marker for LABEL a */
#define  TAC_VAR         14              /* Marker for VAR a */
#define  TAC_BEGINFUNC   15              /* Markers for function */
#define  TAC_ENDFUNC     16

/* The library routines are supplied in an external file. Their entry points
   are held in a table, and we define the offsets in this table here as
   LIB_PRINTN and LIB_PRINTS. At present these are the only two library
   routines, used to print out numbers and strings in PRINT statements. 

   The book assumes that the code generator library and header files are in the
   same directory as the compiler. For greater flexibility we #define a library
   directory here. This will almost certainly need changing for individual
   systems. Note the need for a / at the end of the LIB_DIR. */

#define  LIB_PRINTN     0                /* Index into library entry points */
#define  LIB_PRINTS     1
#define  LIB_MAX        2

/* #define  LIB_DIR  "/jeremy/book/code/"   */ /* Library directory */
/* place the files: lib header in the library directory 
 * change the value of LIB_DIR for the vc compiler to find the 
 * header and lib statically. The '/' as the end of LIB_DIR is MUST
 * */
#define  LIB_DIR  "../lib/"  /* Library directory */

/* Many of the structures we are to use have complex unions and subfields.
   Specifying which field we are want can be verbose and for convenience we
   define some of the subfields. Thus given a pointer to a symbol table entry,
   "sp" the "text" field of the "val1" union would be referred to as
   "sp->val1.text". Instead these #define's allow us to write "sp->TEXT1". */

#define VAL1   val1.val                  /* Value val1 */
#define TEXT1  val1.text                 /* Text val1 */
#define VAL2   val2.val                  /* Value val2 */
#define LABEL2 val2.label                /* Label val2 */
#define ADDR2  val2.val                  /* Address val2 */
#define ETYPE  res->type                 /* Type of expr result */
#define EVAL1  res->val1.val             /* Value field in expr */
#define VA     a.var                     /* Var result in TAC */
#define LA     a.lab                     /* Label result in TAC */
#define VB     b.var                     /* Var first arg in TAC */
#define LB     b.lab                     /* Label first arg in TAC */
#define VC     c.var                     /* Var second arg in TAC */
#define LC     c.lab                     /* Label second arg in TAC */

/* This is the central structure of the compiler, the symbol table entry, SYMB.
   The symbol table takes the form of an open hash table. The entries are
   linked via the "next" field and have a "type" field. The value of this field
   determines the use made of the two value fields, which may hold text
   pointers or intgers. The whole is set up using a typedef for clarity in the
   code.

   For convenience the same structure is used for items like constants and
   labels even if they do not need to be entered into the symbol table. This
   makes for a simpler TAC data structure. */

typedef struct symb                      /* Symbol table entry */
{
        struct symb *next ;              /* Next in chain */
        int          type ;              /* What is this symbol */
        union                            /* Primary value */
        {
                int         val ;        /* For integers */
                char       *text ;       /* For var names */
        } val1 ;
        union                            /* Secondary value */
        {
                int         val ;        /* For offsets etc */
                struct tac *label ;      /* For branches */
        } val2 ;
} SYMB ;

/* TAC is stored as a doubly-linked list of quadruples. In general we will pass
   round pointers to the last generated quadruple in the syntax analyser and
   first generated quadruple in the code generator. The opcode is an integer
   and the argument and the result fields are either pointers to symbol table
   entries or pointers to other TAC quadruples (for branch instructions). The
   names of the fields are based on TAC instructions of the form

      a := b op c

   Again this is implemented as a typedef for convenience */

typedef struct tac                       /* TAC instruction node */
{
        struct tac  *next ;              /* Next instruction */
        struct tac  *prev ;              /* Previous instruction */
        int          op ;                /* TAC instruction */
        union                            /* Result */
        {
                SYMB        *var ;       /* Name */
                struct tac  *lab ;       /* Address */
        } a ;
        union                            /* Operands */
        {
                SYMB        *var ;
                struct tac  *lab ;
        } b ;
        union
        {
                SYMB        *var ;
                struct tac  *lab ;
        } c ;
} TAC ;

/* When translating expressions in the syntax analyser we need to pass back as
   attribute in YACC not only the code for the expression, but where its result
   is stored. For this we use the ENODE structure. The "next" field in this
   allows it to be used for lists of expressions in function calls. typedef is
   again used for clarity */

typedef struct enode                     /* Parser expression */
{
        struct enode *next ;             /* For argument lists */
        TAC          *tac ;              /* The code */
        SYMB         *res ;              /* Where the result is */
} ENODE ;

/* Global variables used throughout the compiler. "symbtab" is the hashtable.
   Each element is a list of symbol table nodes. "library" is an array holding
   the label numbers of the entry points to library routines.

   Temporary variables are given names of the form "Tnnn" where nnn is a unique
   number.  "next_tmp" holds the number of the next temporary and is
   incremented each time one is used. A similar scheme with "next_label" is
   used to assign unique labels of the form "Lnnn". */

extern SYMB *symbtab[HASHSIZE] ;         /* Symbol table */
extern TAC  *library[LIB_MAX] ;          /* Entries for library routines */
extern int   next_tmp ;                  /* Count of temporaries */
extern int   next_label ;                /* Count of labels */

/* Global routines that although defined in one section may be used elsewhere.
   The majority of these are in the main section of the compiler. */

extern SYMB  *mkconst( int  n ) ;        /* In main.c */
extern SYMB  *mklabel( int  l ) ;
extern SYMB  *mktmp( void ) ;
extern TAC   *mktac( int   op,
                     SYMB *a,
                     SYMB *b,
                     SYMB *c ) ;
extern TAC   *join_tac( TAC *c1,
                        TAC *c2 ) ;
extern void   insert( SYMB *s ) ;
extern SYMB  *lookup( char *s ) ;
extern SYMB  *get_symb( void ) ;
extern void   free_symb( SYMB *s ) ;
extern ENODE *get_enode( void ) ;
extern void   free_enode( ENODE *expr ) ;
extern void  *safe_malloc( int  n ) ;
extern void   error( char *str ) ;
extern void   print_instr( TAC *i ) ;

extern void   mkname( char *name ) ;     /* In scanner.l */

extern void   cg( TAC *tl ) ;            /* In cg.c */
