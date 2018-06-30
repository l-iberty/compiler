%{
/******************************************************************************
*******************************************************************************


                         VV    VV    AAAA     SSSSSS 
                         VV    VV   AAAAAA   SSSSSSSS
                         VV    VV  AA    AA  SS      
                         VV    VV  AAAAAAAA  SSSSSSS 
                         VV    VV  AA    AA        SS
                          VV  VV   AA    AA        SS
                           VVVV    AA    AA  SSSSSSSS
                            VV     AA    AA   SSSSSS 


*******************************************************************************
*******************************************************************************

				 VAM Assember
				 ============

   A simple assembler for VAM

   Modifications:
   ==============

   10 Mar 89 JPB:  First version
    9 May 91 JPB:  '"' changed to '\"' for ANSI consistency.

*******************************************************************************
******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define  MAXLAB  0x1000			 /* Number of labels */

/* The instruction set */

#define  I_HALT	 0 			 /* End of program */
#define  I_NOP   1 			 /* Do nothing */
#define  I_TRAP  2 			 /* Output a character */
#define  I_ADD   3 			 /* ADD Rx,Ry */
#define  I_SUB   4 
#define  I_MUL   5 
#define  I_DIV   6 
#define  I_STI   7			 /* STI Rx,offset(Ry) */
#define  I_LDI   8 			 /* LDI offset(Rx),Ry */
#define  I_LDA   9 			 /* LDA offset(Rx),Ry */
#define  I_LDR   10 			 /* LDR Rx,Ry */
#define  I_BZE   11 			 /* BZE offset */
#define  I_BNZ   12 
#define  I_BRA   13
#define  I_BAL   14 			 /* BAL Rx,Ry */
#define  I_MAX   15

/* Global variables */

int  pass ;				 /* Which pass */
int  pc ;				 /* Program counter */
int  labtab[MAXLAB] ;			 /* Offsets for labels */


/* Subsequent routines */

char  *decode_args( int   argc,
		    char *argv[] ) ;

void  setup_files( char *ifile,
		   char *ofile ) ;

void  pbyte( int  n ) ;

void  pword( int  n ) ;

%}

%%

program      :  statement
             |  program statement
             ;

statement    :  comment return
             |  label ':' comment return
		{
			labtab[$1] = pc ;
		}
             |  label ':' ws instruction comment return
		{
			labtab[$1] = pc ;
		}
             |  ws instruction comment return
             ;

label        :  'L' number	{ $$ = $2 ; } 
             ;

number       :  number digit
		{
			$$ = $1 * 10 + $2 ;
		}
	     |  digit
             ;

digit        :  '0'	{ $$ = 0x0 ; }
             |  '1'	{ $$ = 0x1 ; }
             |  '2'	{ $$ = 0x2 ; }
             |  '3'	{ $$ = 0x3 ; }
             |  '4'	{ $$ = 0x4 ; }
             |  '5'	{ $$ = 0x5 ; }
             |  '6'	{ $$ = 0x6 ; }
             |  '7'	{ $$ = 0x7 ; }
             |  '8'	{ $$ = 0x8 ; }
             |  '9'	{ $$ = 0x9 ; }

ws           :  separator
             |  ws separator
             ;

separator    :  ' '
             |  '\t'
             ;

instruction  :  halt_instr
             |  nop_instr
             |  trap_instr
             |  add_instr
             |  sub_instr
             |  mul_instr
             |  div_instr
             |  sti_instr
             |  ldi_instr
             |  lda_instr
             |  ldr_instr
             |  bze_instr
             |  bnz_instr
             |  bra_instr
             |  bal_instr
	     |  db_instr
             ;

halt_instr   :  halt_op		{ pbyte( I_HALT ) ; }
             ;

nop_instr    :  nop_op		{ pbyte( I_NOP ) ; }
             ;

trap_instr   :  trap_op		{ pbyte( I_TRAP ) ; }
             ;

add_instr    :  add_op ws reg ',' reg
		{
			pbyte( I_ADD ) ;
			pbyte( ($3 << 4) | $5 ) ;
		}
             ;

sub_instr    :  sub_op ws reg ',' reg
		{
			pbyte( I_SUB ) ;
			pbyte( ($3 << 4) | $5 ) ;
		}
             ;

mul_instr    :  mul_op ws reg ',' reg
		{
			pbyte( I_MUL ) ;
			pbyte( ($3 << 4) | $5 ) ;
		}
             ;

div_instr    :  div_op ws reg ',' reg
		{
			pbyte( I_DIV ) ;
			pbyte( ($3 << 4) | $5 ) ;
		}
             ;

sti_instr    :  sti_op ws reg ',' offset '(' reg ')'
		{
			pbyte( I_STI ) ;
			pbyte( ($3 << 4) | $7 ) ;
			pword( $5 ) ;
		}
             |  sti_op ws reg ',' label
		{
			pbyte( I_STI ) ;
			pbyte( $3 << 4 ) ;
			pword( labtab[$5] ) ;
		}
             ;

ldi_instr    :  ldi_op ws offset '(' reg ')' ',' reg
		{
			pbyte( I_LDI ) ;
			pbyte( ($5 << 4) | $8 ) ;
			pword( $3 ) ;
		}
             |  ldi_op ws label ',' reg
		{
			pbyte( I_LDI ) ;
			pbyte( $5 ) ;
			pword( labtab[$3] ) ;
		}
             ;

lda_instr    :  lda_op ws offset '(' reg ')' ',' reg
		{
			pbyte( I_LDA ) ;
			pbyte( ($5 << 4) | $8 ) ;
			pword( $3 ) ;
		}
             |  lda_op ws label ',' reg
		{
			pbyte( I_LDA ) ;
			pbyte( $5 ) ;
			pword( labtab[$3] ) ;
		}
             ;

ldr_instr    :  ldr_op ws reg ',' reg
		{
			pbyte( I_LDR ) ;
			pbyte( ($3 << 4) | $5 ) ;
		}
             ;

bze_instr    :  bze_op ws offset
		{
			pbyte( I_BZE ) ;
			pword( $3 ) ;
		}
             |  bze_op ws label
		{
			pbyte( I_BZE ) ;
			pword( labtab[$3] - pc + 1 ) ;
		}
             ;

bnz_instr    :  bnz_op ws offset
		{
			pbyte( I_BNZ ) ;
			pword( $3 ) ;
		}
             |  bnz_op ws label
		{
			pbyte( I_BNZ ) ;
			pword( labtab[$3] - pc + 1 ) ;
		}
             ;

bra_instr    :  bra_op ws offset
		{
			pbyte( I_BRA ) ;
			pword( $3 ) ;
		}
             |  bra_op ws label
		{
			pbyte( I_BRA ) ;
			pword( labtab[$3] - pc + 1 ) ;
		}
             ;

bal_instr    :  bal_op ws reg ',' reg
		{
			pbyte( I_BAL ) ;
			pbyte( ($3 << 4) | $5 ) ;
		}
             ;

db_instr     :  db_op ws number
		{
			pbyte( $3 ) ;
		}
	     ;

halt_op      :  'H' 'A' 'L' 'T'
             ;

nop_op       :  'N' 'O' 'P'
             ;

trap_op      :  'T' 'R' 'A' 'P'
             ;

add_op       :  'A' 'D' 'D'
             ;

sub_op       :  'S' 'U' 'B'
             ;

mul_op       :  'M' 'U' 'L'
             ;

div_op       :  'D' 'I' 'V'
             ;

sti_op       :  'S' 'T' 'I'
             ;

ldi_op       :  'L' 'D' 'I'
             ;

lda_op       :  'L' 'D' 'A'
             ;

ldr_op       :  'L' 'D' 'R'
             ;

bze_op       :  'B' 'Z' 'E'
             ;

bnz_op       :  'B' 'N' 'Z'
             ;

bra_op       :  'B' 'R' 'A'
             ;

bal_op       :  'B' 'A' 'L'
             ;

db_op        :  'D' 'B'
	     ;

reg          :  'R' number	{ $$ = $2 ; }
             ;

offset       :  number
             ;

comment      :  text_comment
	     |  ws text_comment
	     |
	     ;

text_comment :  text_comment char
             |  '\\'
             ;

char         :  separator
             |  'a'
             |  'b'
             |  'c'
             |  'd'
             |  'e'
             |  'f'
             |  'g'
             |  'h'
             |  'i'
             |  'j'
             |  'k'
             |  'l'
             |  'm'
             |  'n'
             |  'o'
             |  'p'
             |  'q'
             |  'r'
             |  's'
             |  't'
             |  'u'
             |  'v'
             |  'w'
             |  'x'
             |  'y'
             |  'z'
             |  'A'
             |  'B'
             |  'C'
             |  'D'
             |  'E'
             |  'F'
             |  'G'
             |  'H'
             |  'I'
             |  'J'
             |  'K'
             |  'L'
             |  'M'
             |  'N'
             |  'O'
             |  'P'
             |  'Q'
             |  'R'
             |  'S'
             |  'T'
             |  'U'
             |  'V'
             |  'W'
             |  'X'
             |  'Y'
             |  'Z'
             |  '0'
             |  '1'
             |  '2'
             |  '3'
             |  '4'
             |  '5'
             |  '6'
             |  '7'
             |  '8'
             |  '9'
             |  '!'
             |  '\"'
             |  '#'
             |  '$'
             |  '%'
             |  '&'
             |  '\''
             |  '('
             |  ')'
             |  '='
             |  '-'
             |  '~'
             |  '^'
             |  '\\'
             |  '|'
             |  '@'
             |  '{'
             |  '['
             |  '`'
             |  '_'
             |  '+'
             |  ';'
             |  ':'
             |  '*'
             |  '}'
             |  ']'
             |  '<'
             |  ','
             |  '>'
             |  '.'
             |  '?'
             |  '/'
             ;

return       :  '\n'
             |  '\r' '\n'
             ;

%%

int   main( int   argc,
	    char *argv[] )

/* Takes a single argument, the file to assemble, which must end in ".vas".
   Send the output to the corresponding file, but ending in ".vam". */

{
	char *ifile ;
	char *ofile ;

	/* Decode the arguments, and setup stdin and stdout accordingly */

	ofile = decode_args( argc, argv ) ;
	ifile = argv[1] ;			/* Do after decode has checked
						   number of file is OK */
	setup_files( ifile, ofile ) ;

	/* First pass sets up labels */

	pass = 1 ;
	yyparse() ;

	/* Second pass generates code */

	rewind( stdin ) ;
	pc   = 0 ;
	pass = 2 ;
	yyparse() ;

	return 0;
}	/* int   main( int argc, char *argv[]) */


char  *decode_args( int   argc,
		    char *argv[] )

/* There should be a single argument, ending in ".vas". Construct a result
   ending in ".vam". */

{
  	char *ofile ;			/* Constructed output file */
	int   len ;			/* Length of input file */

	/* Should be a single argument */

	if( argc != 2 )
	{
	  	fprintf( stderr, "vas: single argument expected\n" ) ;
		exit( 0 ) ;
	}

	/* Find suffix, which must be ".vas" */

	len = strlen( argv[1] ) - strlen( ".vas" ) ;

	if( (len < 1) || (strcmp( argv[1] + len, ".vas" ) != 0) )
	{
	  	fprintf( stderr, "vas: source file must end in \".vas\".\n" ) ;
		exit( 0 ) ;
	}

	/* Allocate for ofile */

	ofile = (char *)malloc( len + strlen( ".vas" ) + 1 ) ;

	if( ofile == NULL )
	{
	  	fprintf( stderr, "vas: decode_args: malloc failed\n" ) ;
		exit( 0 ) ;
	}

	/* Construct the new output file */

	strncpy( ofile, argv[1], len + 1 ) ;	/* Root + '.' */
	strcat( ofile, "vam" ) ;

	return  ofile ;

}	/* decode_args() */


void  setup_files( char *ifile,
		   char *ofile )

/* Substitute the given files for stdin and stdout, remembering that stdout
   should be a binary file */

{
  	/* Input is text. This is the default for DJGPP anyway */

  	if( freopen( ifile, "r", stdin ) == NULL )
	{
	  	perror( "vas: setup_files: freopen( ifile )" ) ;
		exit( 0 ) ;
	}

	/* Output is binary. Force this for DOS using DJGPP with the b flag to
	   freopen. */

#ifdef DJGPP
  	if( freopen( ofile, "wb", stdout ) == NULL )
#else
  	if( freopen( ofile, "w", stdout ) == NULL )
#endif
	{
	  	perror( "vas: setup_files: freopen( ofile )" ) ;
		exit( 0 ) ;
	}

}	/* setup_files() */


int  yylex( void )
{
	return getchar() ;

}	/* int  yylex( void ) */


int   yyerror( char *s )

{
	fprintf( stderr, "yyerror: %s\n", s ) ;
	return  0 ;

}	/* void  yyerror( char *s ) */


void  pbyte( int  n )

/* Put out the single byte n (on pass 2), advancing pc */

{
	if( pass == 2 )
		putchar( n ) ;

	pc++ ;

}	/* void  pbyte( int  n ) */


void  pword( int  n )

/* Put out the word n (on pass 2), advancing pc */

{
	if( pass == 2 )
	{
		putchar( n >> 24 ) ;
		putchar( n >> 16 ) ;
		putchar( n >>  8 ) ;
		putchar( n       ) ;
	}

	pc += 4 ;

}	/* void  pword( int  n ) */
