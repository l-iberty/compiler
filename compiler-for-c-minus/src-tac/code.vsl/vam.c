/******************************************************************************
*******************************************************************************


                         VV    VV    AAAA    MM    MM
                         VV    VV   AAAAAA   MMM  MMM
                         VV    VV  AA    AA  MMMMMMMM
                         VV    VV  AAAAAAAA  MM MM MM
                         VV    VV  AA    AA  MM    MM
                          VV  VV   AA    AA  MM    MM
                           VVVV    AA    AA  MM    MM
                            VV     AA    AA  MM    MM


*******************************************************************************
*******************************************************************************

			VAM - The VSL Abstract Machine
			==============================

   A simulator for the VSL Abstract Machine. This is just a glorified switch
   with signal handling.

   Modifications:
   ==============

    5 Dec 88  JPB: First Version
    9 May 91  JPB: fprintf had stderr inserted as first argument in four
                   places. clock changed to vam_clock to avoid name clashes
                   with certain compilers, where clock is a reserved
                   identifier. (J Johnson, M Haberler and R Tearle)
   28 Apr 92  JPB: bitwise OR used to calculate offsets, rather than addition.
   15 Sep 92  JPB: | replaced || as bitwise operator in previous bug.

*******************************************************************************
******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

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

/* System things */

#define  TRUE    1
#define  FALSE   0
#define  REGMAX  16 			 /* Number of regs */
#define  MEMMAX  (256 * 256)		 /* Bytes of memory */

/* Routine to increment the Z flag */

#define  DO_Z(x)  ((x) == 0 ? (z_flag = TRUE) : (z_flag = FALSE))

/* Global variables */

unsigned int   r[REGMAX] ;		 /* Registers */
unsigned char  mem[MEMMAX] ;		 /* Memory */
unsigned int   pc ;			 /* Program counter */
int            z_flag ;			 /* The Zero flag */
int            vam_clock ;		 /* How many cycles */

char          *image_file ;		 /* Image to load */
int            trace_flag ;		 /* Do we trace each instruction? */

/* Routines */

void  read_args( int   argc,		 /* Handle args */
		 char *argv[] ) ;

void  init_system() ;			 /* Set up the world */

void  vam() ;				 /* Simulator */

int   i_pc() ;				 /* Safely increment the PC */

void  trace( unsigned int   o_pc,	 /* Dump out state */
	     unsigned char  op,
	     int            rx,
	     int            ry,
	     int            offset ) ;

void  print_op( unsigned int   o_pc,	 /* Opcode name */
	        unsigned char  op,
	        int            rx,
	        int            ry,
	        int            offset ) ;


int   main( int   argc,
            char *argv[] )

/* vam takes a single argument, the object file, which is loaded at address
   zero. There is an optional flag, -t, which means trace at each step. */

{
	read_args( argc, argv ) ;	 /* Get the arguments */
	init_system() ;			 /* Set up the machine */
	vam() ;				 /* Run it */
	return 0;
}	/* main() */


void  read_args( int   argc,
		 char *argv[] )

/* Read an optional -t flag and a filename */

{
	int  maxargs = 1 ;		 /* Maxargs expected */
	int  nextarg = 1 ;		 /* Offset of next argument */

	if( argc < 2 )			 /* Must have at least a first arg */
	{
		printf( "vam: Too few args\n" ) ;
		exit( 10 ) ;
	}

	/* Check for trace flag */

	if( strcmp( argv[nextarg], "-t" ) == 0 )
	{
		nextarg++ ;		 /* Step past */
		trace_flag = TRUE ;	 /* Turn on tracing */
	}
	else
		trace_flag = FALSE ;	 /* Turn off tracing */

	/* Get the filename */

	if( argc < nextarg )		 /* Check we have a file */
	{
		printf( "vam: No image file\n" ) ;
		exit( 10 ) ;
	}

	image_file = argv[nextarg] ;

}	/* read_args( argc, argv ) */




void  init_system()

/* Set up the system, ready to run. This means initialising all the registers
   etc. */

{
	int   i ;			 /* For counting */
	int   ch ;			 /* General purpose character */
	FILE *fh ;			 /* File handle for image */

	for( i = 0 ; i < REGMAX ; i++ )	 /* Clear registers */
		r[i] = 0 ;

	for( i = 0 ; i < MEMMAX ; i++ )	 /* Clear main memory */
		mem[i] = 0 ;

	pc = 0 ;			 /* Program counter to start */
	z_flag = FALSE ;		 /* Clear flag */
	vam_clock = 0 ;			 /* Zero clock */

	/* Open and load the image file (binary mode for DOS) */

	fh = fopen( image_file, "rb" ) ;

	if( fh ==  NULL )
	{
		printf( "vam: Couldn't open %s\n", image_file ) ;
		exit( 10 ) ;
	}

	for( i = 0 ; (ch = fgetc( fh )) != EOF ; i++ )
		mem[i] = (char)ch ;

	/* Eventually we'll set up interrupt handling here */

}	/* init_system() */




void  vam()

/* The actual simulator. This is just a switchon in a loop */

{
	unsigned int   o_pc ;		 /* Old pc */
	unsigned char  op ;		 /* Opcode */
	int            rx, ry ;		 /* Registers */
	int            offset ;		 /* Address displacement */
	int            t ;		 /* Temporary value */

	for( ; ; )
	{
		o_pc = pc ;

		switch( op = mem[i_pc()] )
		{
		case I_HALT:

			/* Satisfactory termination */

			vam_clock++ ;
		  if ( trace_flag == TRUE )	 /* print the vam status */
				trace( o_pc, op, rx, ry, offset ) ;
			exit( 0 ) ;

		case I_NOP:

			vam_clock++ ;
			trace( o_pc, op, rx, ry, offset ) ;
			break ;

		case I_TRAP:

			printf( "%c", r[15] ) ;	 /* Print out r[15] in ASCII */
			DO_Z( r[15] ) ;
			vam_clock++ ;
			break ;

		case I_ADD:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;
			DO_Z( r[ry] = r[rx] + r[ry] ) ;
			vam_clock++ ;
			break ;

		case I_SUB:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;
			DO_Z( r[ry] = r[rx] - r[ry] ) ;
			vam_clock++ ;
			break ;

		case I_MUL:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;
			DO_Z( r[ry] = r[rx] * r[ry] ) ;
			vam_clock += 5 ;
			break ;

		case I_DIV:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;

			if( r[ry] == 0 )         /* Check for divide by zero */
			{
				printf( "vam: Divide by zero trap\n" ) ;
				DO_Z( r[ry] = 0 ) ;
				trace( o_pc, op, rx, ry, offset ) ;
			}
			else
				DO_Z( r[ry] = r[rx] / r[ry] ) ;

			vam_clock += 10 ;
			break ;

		case I_STI:

			/* Do the offset calculation by oring in, not addition,
			   so negative offsets are correctly done */

			rx = mem[pc] >> 4 ;		   /* Registers */
			ry = mem[i_pc()] &  0x0f ;
			offset = mem[i_pc()] ;		   /* Offset */
			offset = (offset << 8) | mem[i_pc()] ;
			offset = (offset << 8) | mem[i_pc()] ;
			offset = (offset << 8) | mem[i_pc()] ;

			/* Check we are still in memory first */

			if(( offset + r[ry] + 4 ) > MEMMAX )
			{
				fprintf( stderr, "vam: bus error\n" ) ;
				trace( o_pc, op, rx, ry, offset ) ;
				exit( 10 ) ;
			}

			mem[offset + r[ry]]     = r[rx] >> 24        ;
			mem[offset + r[ry] + 1] = r[rx] >> 16 & 0xff ;
			mem[offset + r[ry] + 2] = r[rx] >>  8 & 0xff ;
			mem[offset + r[ry] + 3] = r[rx]       & 0xff ;
			DO_Z( r[rx] ) ;
			vam_clock += 2 ;
			break ;

		case I_LDI:
		case I_LDA:

			/* Do the offset calculation by oring in, not addition,
			   so negative offsets are correctly done */

			rx = mem[pc] >> 4 ;		   /* Registers */
			ry = mem[i_pc()] &  0x0f ;
			offset = mem[i_pc()] ;		   /* Offset */
			offset = (offset << 8) | mem[i_pc()] ;
			offset = (offset << 8) | mem[i_pc()] ;
			offset = (offset << 8) | mem[i_pc()] ;

			/* For LDA just do the operation */

			if( op == I_LDA )
			{
				DO_Z( r[ry] = offset + r[rx] ) ;
				vam_clock += 2 ;
				break ;
			}

			/* For LDI Check we are still in memory first */

			if(( offset + r[rx] + 4 ) > MEMMAX )
			{
				fprintf( stderr, "vam: bus error\n" ) ;
				trace( o_pc, op, rx, ry, offset ) ;
				exit( 10 ) ;
			}

			t =            mem[offset + r[rx]    ] ;
			t = (t << 8) + mem[offset + r[rx] + 1] ;
			t = (t << 8) + mem[offset + r[rx] + 2] ;
			t = (t << 8) + mem[offset + r[rx] + 3] ;
			DO_Z( r[ry] = t ) ;
			vam_clock += 2 ;
			break ;

		case I_LDR:

			rx = mem[pc] >> 4 ;		   /* Registers */
			ry = mem[i_pc()] &  0x0f ;
			vam_clock++ ;
			DO_Z( r[ry] = r[rx] ) ;
			break ;

		case I_BZE:
		case I_BNZ:
		case I_BRA:

			/* Do the offset calculation by oring in, not addition,
			   so negative offsets are correctly done */

			offset = mem[i_pc()] ;		   /* Offset */
			offset = (offset << 8) | mem[i_pc()] ;
			offset = (offset << 8) | mem[i_pc()] ;
			offset = (offset << 8) | mem[i_pc()] ;

			/* Do we do the branch? */

			if((( op == I_BZE ) && z_flag )  ||
			   (( op == I_BNZ ) && !z_flag ) ||
			    ( op == I_BRA ))
			{

				/* Check we are still in memory first */

				if(( offset + pc - 3 ) >= MEMMAX )
				{
					fprintf( stderr, "vam: bus error\n" ) ;
					trace( o_pc, op, rx, ry, offset ) ;
					exit( 10 ) ;
				}

				vam_clock++ ;             /* Extra tick */
				pc += offset - 5 ;
			}

			vam_clock++ ;
			break ;

		case I_BAL:

			rx = mem[pc] >> 4 ;		   /* Registers */
			ry = mem[i_pc()] &  0x0f ;

			/* Check we are still in memory first */

			if( r[rx] >= MEMMAX )
			{
				fprintf( stderr, "vam: bus error\n" ) ;
				trace( o_pc, op, rx, ry, offset ) ;
				exit( 10 ) ;
			}

			t     = pc ;
			pc    = r[rx] ;
			r[ry] = t ;
			vam_clock += 2 ;
			break ;

		default:

			printf( "vam: Instruction trap %02x\n", op ) ;

		}

		if( trace_flag )
			trace( o_pc, op, rx, ry, offset ) ;
	}

}	/* vam() */




int  i_pc()

/* Increment the program counter, so long as we stay in memory. Return the OLD
   value */

{
	if( pc++ < MEMMAX )
		return pc - 1 ;

	printf( "vam: bus error\n" ) ;
	exit( 10 ) ;

}	/* i_pc() */




void  trace( unsigned int   o_pc,
	     unsigned char  op,
	     int            rx,
	     int            ry,
	     int            offset )
 
/* Dump out the registers, program counter, and memory near the program counter
*/

{
	unsigned  int  b ;		 /* Base for memory dump */

	b = pc < 16 ? 0 : (pc + 32) < MEMMAX ? pc & 0xfffffff0 : MEMMAX - 32 ;

	print_op( o_pc, op, rx, ry, offset ) ;

	printf( "R0  = %08x   ",   r[0] ) ;   /* Registers */
	printf( "R1  = %08x   ",   r[1] ) ;
	printf( "R2  = %08x   ",   r[2] ) ;
	printf( "R3  = %08x\n",    r[3] ) ;
	printf( "R4  = %08x   ",   r[4] ) ;
	printf( "R5  = %08x   ",   r[5] ) ;
	printf( "R6  = %08x   ",   r[6] ) ;
	printf( "R7  = %08x\n",    r[7] ) ;
	printf( "R8  = %08x   ",   r[8] ) ;
	printf( "R9  = %08x   ",   r[9] ) ;
	printf( "R10 = %08x   ",   r[10] ) ;
	printf( "R11 = %08x\n",    r[11] ) ;
	printf( "R12 = %08x   ",   r[12] ) ;
	printf( "R13 = %08x   ",   r[13] ) ;
	printf( "R14 = %08x   ",   r[14] ) ;
	printf( "R15 = %08x\n\n",  r[15] ) ;

	printf( "PC  = %08x   ", pc ) ;	      /* PC */
	printf( "Z   = %8x   ", z_flag ) ;    /* Status flag */
	printf( "CLK = %d\n\n", vam_clock ) ; /* Number of ticks */

	printf( "%08x:  ", b ) ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x\n", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%08x:  ", b ) ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x\n", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%08x:  ", b ) ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x\n\n",
	        mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;

	b = r[1] < 16 ? 0 : (r[1] + 32) < MEMMAX ? r[1] & 0xfffffff0 :
						   MEMMAX - 32 ;

	printf( "%08x:  ", b ) ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x\n", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%08x:  ", b ) ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x\n", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%08x:  ", b ) ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x ", mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;
	b += 4 ;
	printf( "%02x%02x%02x%02x\n\n\n",
	        mem[b], mem[b+1], mem[b+2], mem[b+3] ) ;

	fflush( stdout ) ;

}	/* trace( o_pc, op, rx, ry, offset ) */




void  print_op( unsigned int   o_pc,
	        unsigned char  op,
	        int            rx,
	        int            ry,
	        int            offset )

/* Print out opcode */

{
	switch( op )
	{
	case I_HALT:
 
		printf( "%08x:  HALT\n\n", o_pc ) ;
		return ;

	case I_NOP:
  
		printf( "%08x:  NOP\n\n", o_pc ) ;
		return ;

	case I_TRAP:
 
		printf( "%08x:  TRAP\n\n", o_pc ) ;
		return ;

	case I_ADD:
  
		printf( "%08x:  ADD  R%d,R%d\n\n", o_pc, rx, ry) ;
		return ;

	case I_SUB:
  
		printf( "%08x:  SUB  R%d,R%d\n\n", o_pc, rx, ry) ;
		return ;

	case I_MUL:
  
		printf( "%08x:  MUL  R%d,R%d\n\n", o_pc, rx, ry) ;
		return ;

	case I_DIV:
  
		printf( "%08x:  DIV  R%d,R%d\n\n", o_pc, rx, ry) ;
		return ;

	case I_STI:
  
		printf( "%08x:  STI  R%d,%d(R%d)\n\n", o_pc, rx, offset, ry ) ;
		return ;

	case I_LDI:
  
		printf( "%08x:  LDI  %d(R%d),R%d\n\n", o_pc, offset, rx, ry ) ;
		return ;

	case I_LDA:
  
		printf( "%08x:  LDA  %d(R%d),R%d\n\n", o_pc, offset, rx, ry ) ; 
		return ;

	case I_LDR:
  
		printf( "%08x:  LDR  R%d,R%d\n\n", o_pc, rx, ry) ;
		return ;

	case I_BZE:
  
		printf( "%08x:  BZE  %d\n\n", o_pc, offset ) ;
		return ;

	case I_BNZ:
  
		printf( "%08x:  BNZ  %d\n\n", o_pc, offset ) ;
		return ;

	case I_BRA:
  
		printf( "%08x:  BRA  %d\n\n", o_pc, offset ) ;
		return ;

	case I_BAL:
  
		printf( "%08x:  BAL  R%d,R%d\n\n", o_pc, rx, ry) ;
		return ;

	default:
     
		printf( "%08x:  ???\n\n", o_pc ) ;
	}

}
