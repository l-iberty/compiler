/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 37 "parser.y" /* yacc.c:339  */


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


#line 114 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    FUNC = 258,
    VARIABLE = 259,
    ASSIGN_SYMBOL = 260,
    INTEGER = 261,
    PRINT = 262,
    TEXT = 263,
    RETURN = 264,
    CONTINUE = 265,
    IF = 266,
    THEN = 267,
    ELSE = 268,
    FI = 269,
    WHILE = 270,
    DO = 271,
    DONE = 272,
    VAR = 273,
    UMINUS = 274
  };
#endif
/* Tokens.  */
#define FUNC 258
#define VARIABLE 259
#define ASSIGN_SYMBOL 260
#define INTEGER 261
#define PRINT 262
#define TEXT 263
#define RETURN 264
#define CONTINUE 265
#define IF 266
#define THEN 267
#define ELSE 268
#define FI 269
#define WHILE 270
#define DO 271
#define DONE 272
#define VAR 273
#define UMINUS 274

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 92 "parser.y" /* yacc.c:355  */

        SYMB   *symb ;           /* For vars, consts and text */
        TAC    *tac ;            /* For most things */
        ENODE  *enode ;          /* For expressions */

#line 198 "y.tab.c" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 213 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  7
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   110

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  29
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  22
/* YYNRULES -- Number of rules.  */
#define YYNRULES  49
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  83

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   274

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      24,    25,    22,    20,    26,    21,     2,    23,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    27,     2,    28,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   163,   163,   178,   179,   193,   198,   205,   207,   212,
     216,   227,   228,   229,   230,   231,   232,   233,   234,   241,
     251,   255,   259,   263,   267,   271,   275,   279,   299,   303,
     311,   314,   317,   318,   328,   334,   335,   344,   353,   363,
     373,   382,   386,   393,   399,   406,   409,   415,   421,   423
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FUNC", "VARIABLE", "ASSIGN_SYMBOL",
  "INTEGER", "PRINT", "TEXT", "RETURN", "CONTINUE", "IF", "THEN", "ELSE",
  "FI", "WHILE", "DO", "DONE", "VAR", "UMINUS", "'+'", "'-'", "'*'", "'/'",
  "'('", "')'", "','", "'{'", "'}'", "$accept", "program", "function_list",
  "function", "parameter_list", "variable_list", "statement",
  "assignment_statement", "expression", "argument_list", "expression_list",
  "print_statement", "print_list", "print_item", "return_statement",
  "null_statement", "if_statement", "while_statement", "block",
  "declaration_list", "declaration", "statement_list", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
      43,    45,    42,    47,    40,    41,    44,   123,   125
};
# endif

#define YYPACT_NINF -40

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-40)))

#define YYTABLE_NINF -31

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
      46,   -40,     1,     8,    40,   -40,    13,   -40,   -40,    22,
     -40,    23,    26,    54,    55,   -40,    61,    72,    66,   -40,
      66,    66,   -40,   -40,   -40,   -40,   -40,   -40,   -40,   -40,
     -40,   -40,    66,   -40,    36,   -40,   -40,    66,    66,    87,
      42,   -40,    87,    77,     2,    35,    87,    50,   -40,    81,
      66,    66,    66,    66,    72,    54,    54,    22,   -40,   -40,
       0,    62,    52,   -40,   -40,   -10,   -10,   -40,   -40,   -40,
      17,    69,    26,   -40,   -40,    66,   -40,    54,   -40,   -40,
     -40,    65,   -40
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     6,     0,     0,     0,     3,     0,     1,     4,     8,
       9,     0,     7,     0,     0,    18,     0,     0,     0,    40,
       0,     0,    45,     5,    11,    13,    12,    14,    15,    16,
      17,    10,     0,    29,    27,    26,    38,     0,     0,    37,
      34,    35,    39,     0,     0,     0,    19,     0,    24,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    48,    46,
       0,    32,     0,    31,    25,    20,    21,    22,    23,    36,
       0,     0,    47,    44,    49,     0,    28,     0,    41,    43,
      33,     0,    42
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -40,   -40,   -40,    88,   -40,    34,   -39,   -40,   -18,   -40,
      19,   -40,   -40,    41,   -40,   -40,   -40,   -40,   -40,   -40,
     -40,   -40
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     3,     4,     5,    11,    12,    23,    24,    39,    62,
      63,    25,    40,    41,    26,    27,    28,    29,    30,    45,
      59,    60
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      42,    15,    43,    44,    16,     6,    58,    17,     7,    18,
      19,    20,    52,    53,    46,    21,    70,    71,    56,    48,
      49,    74,    50,    51,    52,    53,    10,    22,    73,    61,
      77,    78,    65,    66,    67,    68,    15,     9,    81,    16,
      -2,     1,    17,     2,    18,    19,    20,     1,    13,     2,
      21,    33,    14,    57,    34,    15,    35,    61,    16,    31,
      47,    17,    22,    18,    19,    20,    32,    33,    54,    21,
      34,    37,    35,    33,    38,   -30,    34,    76,    35,    82,
      36,    22,    50,    51,    52,    53,    79,    37,    75,    55,
      38,    72,     8,    37,    80,    69,    38,    50,    51,    52,
      53,    50,    51,    52,    53,     0,    64,    50,    51,    52,
      53
};

static const yytype_int8 yycheck[] =
{
      18,     1,    20,    21,     4,     4,    45,     7,     0,     9,
      10,    11,    22,    23,    32,    15,    55,    56,    16,    37,
      38,    60,    20,    21,    22,    23,     4,    27,    28,    47,
      13,    14,    50,    51,    52,    53,     1,    24,    77,     4,
       0,     1,     7,     3,     9,    10,    11,     1,    25,     3,
      15,     1,    26,    18,     4,     1,     6,    75,     4,     4,
      24,     7,    27,     9,    10,    11,     5,     1,    26,    15,
       4,    21,     6,     1,    24,    25,     4,    25,     6,    14,
       8,    27,    20,    21,    22,    23,    17,    21,    26,    12,
      24,    57,     4,    21,    75,    54,    24,    20,    21,    22,
      23,    20,    21,    22,    23,    -1,    25,    20,    21,    22,
      23
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     1,     3,    30,    31,    32,     4,     0,    32,    24,
       4,    33,    34,    25,    26,     1,     4,     7,     9,    10,
      11,    15,    27,    35,    36,    40,    43,    44,    45,    46,
      47,     4,     5,     1,     4,     6,     8,    21,    24,    37,
      41,    42,    37,    37,    37,    48,    37,    24,    37,    37,
      20,    21,    22,    23,    26,    12,    16,    18,    35,    49,
      50,    37,    38,    39,    25,    37,    37,    37,    37,    42,
      35,    35,    34,    28,    35,    26,    25,    13,    14,    17,
      39,    35,    14
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    29,    30,    31,    31,    32,    32,    33,    33,    34,
      34,    35,    35,    35,    35,    35,    35,    35,    35,    36,
      37,    37,    37,    37,    37,    37,    37,    37,    37,    37,
      38,    38,    39,    39,    40,    41,    41,    42,    42,    43,
      44,    45,    45,    46,    47,    48,    48,    49,    50,    50
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     1,     2,     6,     1,     1,     0,     1,
       3,     1,     1,     1,     1,     1,     1,     1,     1,     3,
       3,     3,     3,     3,     2,     3,     1,     1,     4,     1,
       0,     1,     1,     3,     2,     1,     3,     1,     1,     2,
       1,     5,     7,     5,     4,     0,     2,     2,     1,     2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 164 "parser.y" /* yacc.c:1646  */
    {
                                        program_tac = (yyvsp[0].tac) ;
                                }
#line 1353 "y.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 180 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = join_tac( (yyvsp[-1].tac), (yyvsp[0].tac) ) ;
                                }
#line 1361 "y.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 195 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = do_func( (yyvsp[-4].symb), (yyvsp[-2].tac), (yyvsp[0].tac) ) ;
                                }
#line 1369 "y.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 199 "parser.y" /* yacc.c:1646  */
    {
                                        error( "Bad function syntax" ) ;
                                        (yyval.tac) = NULL ;
                                }
#line 1378 "y.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 207 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = NULL ;
                                }
#line 1386 "y.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 213 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = declare_var( (yyvsp[0].symb) ) ;
                                }
#line 1394 "y.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 217 "parser.y" /* yacc.c:1646  */
    {
                                        /* If we get a duplicate declaration,
                                           t will be NULL. join_tac handles
                                           this correctly. */

                                        (yyval.tac) = join_tac( declare_var( (yyvsp[0].symb) ),
                                                       (yyvsp[-2].tac) ) ;
                                }
#line 1407 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 235 "parser.y" /* yacc.c:1646  */
    {
                                        error( "Bad statement syntax" ) ;
                                        (yyval.tac) = NULL ;
                                }
#line 1416 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 242 "parser.y" /* yacc.c:1646  */
    {

                                        (yyval.tac) = do_assign( (yyvsp[-2].symb), (yyvsp[0].enode) ) ;
                                }
#line 1425 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 252 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = do_bin( TAC_ADD, (yyvsp[-2].enode), (yyvsp[0].enode) ) ;
                                }
#line 1433 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 256 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = do_bin( TAC_SUB, (yyvsp[-2].enode), (yyvsp[0].enode) ) ;
                                }
#line 1441 "y.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 260 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = do_bin( TAC_MUL, (yyvsp[-2].enode), (yyvsp[0].enode) ) ;
                                }
#line 1449 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 264 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = do_bin( TAC_DIV, (yyvsp[-2].enode), (yyvsp[0].enode) ) ;
                                }
#line 1457 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 268 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = do_un( TAC_NEG, (yyvsp[0].enode) ) ;
                                }
#line 1465 "y.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 272 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = (yyvsp[-1].enode) ;
                                }
#line 1473 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 276 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = mkenode( NULL, (yyvsp[0].symb), NULL ) ;
                                }
#line 1481 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 280 "parser.y" /* yacc.c:1646  */
    {
                                        /* Check the variable is declared. If
                                           not we subsitute constant zero, or
                                           we get all sorts of problems later
                                           on. */

                                        if( (yyvsp[0].symb)->type != T_VAR )
                                        {
                                                error( "Undeclared variable in"
                                                     " expression" ) ;

                                                (yyval.enode) = mkenode( NULL,
                                                              mkconst( 0 ),
                                                              NULL ) ;
                                        }
                                        else
                                                (yyval.enode) = mkenode( NULL, (yyvsp[0].symb),
                                                              NULL ) ;
                                }
#line 1505 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 300 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = do_fnap( (yyvsp[-3].symb), (yyvsp[-1].enode) ) ;
                                }
#line 1513 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 304 "parser.y" /* yacc.c:1646  */
    {
                                        error( "Bad expression syntax" ) ;
                                        (yyval.enode) = mkenode( NULL, NULL, NULL ) ;
                                }
#line 1522 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 311 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.enode) = NULL ;
                                }
#line 1530 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 319 "parser.y" /* yacc.c:1646  */
    {

                                        /* Construct a list of expr nodes */

                                        (yyvsp[-2].enode)->next = (yyvsp[0].enode) ;
                                        (yyval.enode)       = (yyvsp[-2].enode) ;
                                }
#line 1542 "y.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 329 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = (yyvsp[0].tac) ;
                                }
#line 1550 "y.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 336 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = join_tac( (yyvsp[-2].tac), (yyvsp[0].tac) ) ;
                                }
#line 1558 "y.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 345 "parser.y" /* yacc.c:1646  */
    {

                                        /* Call printn library routine */

                                        (yyval.tac) = join_tac( (yyvsp[0].enode)->tac,
                                                       do_lib( LIB_PRINTN,
                                                       (yyvsp[0].enode)->res )) ;
                                }
#line 1571 "y.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 354 "parser.y" /* yacc.c:1646  */
    {

                                        /* Call prints, passing the address of
                                           the string */

                                        (yyval.tac) = do_lib( LIB_PRINTS, (yyvsp[0].symb) ) ;
                                }
#line 1583 "y.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 364 "parser.y" /* yacc.c:1646  */
    {
                                        TAC *t = mktac( TAC_RETURN, (yyvsp[0].enode)->res,
                                                        NULL, NULL ) ;
                                        t->prev = (yyvsp[0].enode)->tac ;
                                        free_enode( (yyvsp[0].enode) ) ;
                                        (yyval.tac)      = t ;
                                }
#line 1595 "y.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 374 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = NULL ;
                                }
#line 1603 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 383 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = do_if( (yyvsp[-3].enode), (yyvsp[-1].tac) ) ;
                                }
#line 1611 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 388 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = do_test( (yyvsp[-5].enode), (yyvsp[-3].tac), (yyvsp[-1].tac) ) ;
                                }
#line 1619 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 394 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = do_while( (yyvsp[-3].enode), (yyvsp[-1].tac) ) ;
                                }
#line 1627 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 400 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = join_tac( (yyvsp[-2].tac), (yyvsp[-1].tac) ) ;
                                }
#line 1635 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 406 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = NULL ;
                                }
#line 1643 "y.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 410 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = join_tac( (yyvsp[-1].tac), (yyvsp[0].tac) ) ;
                                }
#line 1651 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 416 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = (yyvsp[0].tac) ;
                                }
#line 1659 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 424 "parser.y" /* yacc.c:1646  */
    {
                                        (yyval.tac) = join_tac( (yyvsp[-1].tac), (yyvsp[0].tac) ) ;
                                }
#line 1667 "y.tab.c" /* yacc.c:1646  */
    break;


#line 1671 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 429 "parser.y" /* yacc.c:1906  */


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
