//
// Created by l-iberty on 3/29/18.
//

#ifndef LEXANALYZE_XMLHELPER_H
#define LEXANALYZE_XMLHELPER_H

#include <libxml/parser.h>
#include <libxml/tree.h>

/**
 * 单词符号的类别(classification)编码
 */
#define $IDENTIFIER     1                   /* identifier */
#define $CONSTANT       $IDENTIFIER + 1     /* constant */
#define $INT            $CONSTANT + 1       /* int */
#define $VOID           $INT + 1            /* void */
#define $IF             $VOID + 1           /* if */
#define $ELSE           $IF + 1             /* else */
#define $WHILE          $ELSE + 1           /* while */
#define $FOR            $WHILE + 1          /* for */
#define $RETURN         $FOR + 1            /* return */
#define $ADD            $RETURN + 1         /* + */
#define $SUB            $ADD + 1            /* - */
#define $MUL            $SUB + 1            /* * */
#define $DIV            $MUL + 1            /* / */
#define $L              $DIV + 1            /* < */
#define $LE             $L + 1              /* <= */
#define $G              $LE + 1             /* > */
#define $GE             $G + 1              /* >= */
#define $NE             $GE + 1             /* != */
#define $E              $NE + 1             /* == */
#define $ASSIGN         $E + 1              /* = */
#define $LPAR           $ASSIGN + 1         /* ( */
#define $RPAR           $LPAR + 1           /* ) */
#define $LBRA           $RPAR + 1           /* { */
#define $RBRA           $LBRA + 1           /* } */
#define $COM            $RBRA + 1           /* , */
#define $SEM            $COM + 1            /* ; */

/**
 * 符号表中无定义的的位置编号
 */
#define NONE        0

#define BIN_FILE   "bin.xml"
#define SYM_FILE   "sym.xml"

/**
 * 创建 bin.xml & sym.xml
 */
void create_xml_file();

/**
 *
 * @param root      根节点
 * @param content   待查找节点内容
 * @return          查找到的节点, or NULL if not found
 */
xmlNodePtr find_node(xmlNodePtr root, xmlChar *content);

/**
 *
 * @param word  标识符或常量
 * @param code 类编编码,标识符 or 常量
 * @param id    标识符或常量在符号表中的位置编号,即在文件中的出现次序
 */
void add_to_symboltable(char *word, int code, int id);

/**
 *
 * @param code 单词符号的类别编码
 * @param id    单词符号在符号表中的位置编号.只对标识符和常数有定义
 */
void add_binary_formula(int code, int id);

/**
 * 保存 bin.xml & sym.xml
 */
void save_xml_file();

#endif //LEXANALYZE_XMLHELPER_H
