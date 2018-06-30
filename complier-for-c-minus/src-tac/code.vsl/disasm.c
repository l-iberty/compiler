/******************************************************************************
*******************************************************************************

			DISASM - The VSL Disassembler
			=============================

   A disassembler for the VSL Abstract Machine. This is just a glorified
   switch.

   Modifications:
   ==============

   20 Jan 96: Jeremy Bennett. First version

*******************************************************************************
******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

#define  MEMMAX  (256 * 256)		 /* Bytes of memory */


/* Global variables */

unsigned char  mem[MEMMAX] ;		 /* Memory */
unsigned int   pc ;			 /* Program counter */
char          *image_file ;		 /* Image to load */
int            maxmem ;			 /* Top of memory */

/* Routines */

void  read_args( int   argc,		 /* Handle args */
		 char *argv[] ) ;

void  init_system() ;			 /* Set up the world */

void  disasm() ;			 /* Disassembler */

int   i_pc() ;				 /* Safely increment the PC */

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
	disasm() ;				 /* Run it */
	return 0;
}	/* main() */


void  read_args( int   argc,
		 char *argv[] )

/* Get a filename */

{
	if( argc != 2 )			 /* Must have a first arg */
	{
		printf( "disasm: arg missing\n" ) ;
		exit( 10 ) ;
	}

	image_file = argv[1] ;

}	/* read_args( argc, argv ) */




void  init_system()

/* Set up the system, ready to run. This means initialising all the registers
   etc. */

{
	int   ch ;			 /* General purpose character */
	FILE *fh ;			 /* File handle for image */

	pc = 0 ;			 /* Program counter to start */

	/* Open and load the image file */

	fh = fopen( image_file, "rb" ) ;

	if( fh ==  NULL )
	{
		printf( "disasm: Couldn't open %s\n", image_file ) ;
		exit( 10 ) ;
	}

	for( maxmem = 0 ; (ch = fgetc( fh )) != EOF ; maxmem++ )
		mem[maxmem] = (char)ch ;

}	/* init_system() */


void  disasm()

/* The actual simulator. This is just a switchon in a loop */

{
	unsigned int   o_pc ;		 /* Old pc */
	unsigned char  op ;		 /* Opcode */
	int            rx, ry ;		 /* Registers */
	int            offset ;		 /* Address displacement */

	while( pc <= maxmem )
	{
		o_pc = pc ;

		switch( op = mem[i_pc()] )
		{
		case I_HALT:

			/* Satisfactory termination */

			break ;

		case I_NOP:

			break ;

		case I_TRAP:

			break ;

		case I_ADD:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;

			break ;

		case I_SUB:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;

			break ;

		case I_MUL:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;

			break ;

		case I_DIV:

			rx = mem[pc] >> 4 ;	 /* Registers */
			ry = mem[i_pc()] &  0x0f ;

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

			break ;

		case I_LDR:

			rx = mem[pc] >> 4 ;		   /* Registers */
			ry = mem[i_pc()] &  0x0f ;

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

			break ;

		case I_BAL:

			rx = mem[pc] >> 4 ;		   /* Registers */
			ry = mem[i_pc()] &  0x0f ;

			break ;
		}

		print_op( o_pc, op, rx, ry, offset ) ;
		}

}	/* disasm() */




int  i_pc()

/* Increment the program counter, so long as we stay in memory. Return the OLD
   value */

{
	if( pc++ < MEMMAX )
		return pc - 1 ;

	printf( "disasm: bus error\n" ) ;
	exit( 10 ) ;

}	/* i_pc() */


void  print_op( unsigned int   o_pc,
	        unsigned char  op,
	        int            rx,
	        int            ry,
	        int            offset )

/* Print out opcode */

{
  	/* The address */

	printf( "%08x: %02x ", o_pc, op % 256 ) ;

	/* The instruction as hex */

	switch( op )
	{
	default:
	case I_HALT:
	case I_NOP:
	case I_TRAP:

	        printf( "                 " ) ;
	  	break ;

	case I_ADD:
  	case I_SUB:
  	case I_MUL:
  	case I_DIV:
	case I_LDR:
  
		printf( "%02x               ", rx << 4 | ry ) ;
		break ;

	case I_STI:
	case I_LDI:
	case I_LDA:
  
		printf( "%02x %02x %02x %02x %02x   ", rx << 4 | ry,
		        (offset >> 24) & 0xff,
		        (offset >> 16) & 0xff,
		        (offset >>  8) & 0xff,
		        offset & 0xff ) ;

		break ;

	case I_BZE:
  	case I_BNZ:
  	case I_BRA:
  	case I_BAL:
  
		printf( "%02x %02x %02x %02x      ",
		        (offset >> 24) & 0xff,
		        (offset >> 16) & 0xff,
		        (offset >>  8) & 0xff,
		        offset & 0xff ) ;

		break ;
	}

	/* Now the opcode */

	switch( op )
	{
	case I_HALT:
 
		printf( "HALT\n" ) ;
		return ;

	case I_NOP:
  
		printf( "NOP\n" ) ;
		return ;

	case I_TRAP:
 
		printf( "TRAP\n" ) ;
		return ;

	case I_ADD:
  
		printf( "ADD  R%d,R%d\n", rx, ry) ;
		return ;

	case I_SUB:
  
		printf( "SUB  R%d,R%d\n", rx, ry) ;
		return ;

	case I_MUL:
  
		printf( "MUL  R%d,R%d\n", rx, ry) ;
		return ;

	case I_DIV:
  
		printf( "DIV  R%d,R%d\n", rx, ry) ;
		return ;

	case I_STI:
  
		printf( "STI  R%d,%d(R%d)\n", rx, offset, ry ) ;
		return ;

	case I_LDI:
  
		printf( "LDI  %d(R%d),R%d\n", offset, rx, ry ) ;
		return ;

	case I_LDA:
  
		printf( "LDA  %d(R%d),R%d\n", offset, rx, ry ) ; 
		return ;

	case I_LDR:
  
		printf( "LDR  R%d,R%d\n", rx, ry) ;
		return ;

	case I_BZE:
  
		printf( "BZE  %d\n", offset ) ;
		return ;

	case I_BNZ:
  
		printf( "BNZ  %d\n", offset ) ;
		return ;

	case I_BRA:
  
		printf( "BRA  %d\n", offset ) ;
		return ;

	case I_BAL:
  
		printf( "BAL  R%d,R%d\n", rx, ry) ;
		return ;

	default:
     
		printf( "???\n" ) ;
	}

}
