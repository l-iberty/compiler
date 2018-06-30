#ifndef LEX_H
#define LEX_H

#include <libxml/parser.h>
#include <libxml/tree.h>

#define HASHSIZE	997
#define MAX_NAME	32

typedef struct _SYMBOL {
	int code; /* 单词符号的类别编码 */
	int val; /* used for constant only */
	char text[MAX_NAME]; /* literal text of constant, or name of identifier */
} SYMBOL;



/**
 * 单词符号的类别编码
 */
#define $IDENTIFIER     1                   	/* identifier */
#define $CONSTANT       $IDENTIFIER + 1     	/* constant */
#define $INT            $CONSTANT + 1       	/* int */
#define $VOID           $INT + 1            	/* void */
#define $BOOL		$VOID + 1		/* bool */
#define $_TRUE		$BOOL + 1		/* true */
#define $_FALSE		$_TRUE + 1		/* false */
#define $IF             $_FALSE + 1           	/* if */
#define $ELSE           $IF + 1             	/* else */
#define $WHILE          $ELSE + 1           	/* while */
#define $BREAK          $WHILE + 1          	/* break */
#define $RETURN         $BREAK + 1            	/* return */
#define $ADD            '+'	         	/* + */
#define $SUB            '-'	            	/* - */
#define $MUL            '*'             	/* * */
#define $DIV            '/'	           	/* / */
#define $MOD		'%'			/* % */
#define $BIT_OR		'|'			/* | */
#define $BIT_AND	'&'			/* & */
#define $NOT		'!'			/* ! */
#define $L              '<'	            	/* < */
#define $LE             $RETURN + 1            	/* <= */
#define $G              '>'             	/* > */
#define $GE             $LE + 1              	/* >= */
#define $NE             $GE + 1             	/* != */
#define $E              $NE + 1             	/* == */
#define $ASSIGN         '='              	/* = */
#define $ADD_ASSIGN	$E + 1			/* += */
#define $SUB_ASSIGN	$ADD_ASSIGN + 1		/* -= */
#define $LPAR           '('	        	/* ( */
#define $RPAR           ')'	           	/* ) */
#define $LBRA           '{'	           	/* { */
#define $RBRA           '}'	           	/* } */
#define $LSBRA		'['			/* [ */
#define $RSBRA		']'			/* ] */
#define $COM            ','	           	/* , */
#define $SEM            ';'	            	/* ; */

/**
 * 符号表中无定义的的位置编号
 */
#define NONE        -1

#define BIN_FILE   "bin.xml"
#define SYM_FILE   "sym.xml"

/**
 * 创建 bin.xml & sym.xml
 */
void create_lexical_xml_file();

/**
 *
 * @param root      根节点
 * @param content   待查找节点内容
 * @return          查找到的节点, or NULL if not found
 */
xmlNodePtr find_node(xmlNodePtr root, xmlChar *content);

/**
 *
 * @param token		单词符号
 * @return		单词符号在符号表中的位置编号
 */
int find_symbol(char* token);

/**
 *
 * @param token 	单词符号
 * @param code		单词符号的类编编码
 *
 * @return		单词符号在符号表中的位置编号
 */
int add_to_symboltable(char *token, int code);

/**
 *
 * @param code		单词符号的类别编码
 * @param id		单词符号在符号表中的位置编号.只对标识符和常数有定义
 */
void add_binary_formula(int code, int id);

/**
 * 保存 bin.xml & sym.xml
 */
void save_lexical_xml_file();




#endif // LEX_H

