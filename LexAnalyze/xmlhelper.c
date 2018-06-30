//
// Created by l-iberty on 3/29/18.
//

#include <stdio.h>
#include "xmlhelper.h"

/**
 * 二元式文件
 */
xmlDocPtr g_bindoc = NULL;
xmlNodePtr g_binroot = NULL;

/**
 * 符号表文件
 */
xmlDocPtr g_symdoc = NULL;
xmlNodePtr g_symroot = NULL;

void create_xml_file() {
    g_bindoc = xmlNewDoc(BAD_CAST "1.0");
    g_binroot = xmlNewNode(NULL, BAD_CAST "bin_table");
    xmlDocSetRootElement(g_bindoc, g_binroot);

    g_symdoc = xmlNewDoc(BAD_CAST "1.0");
    g_symroot = xmlNewNode(NULL, BAD_CAST "sym_table");
    xmlDocSetRootElement(g_symdoc, g_symroot);
}

xmlNodePtr find_node(xmlNodePtr root, xmlChar *content) {
    if (root == NULL)
        return NULL;

    xmlNodePtr cur;
    for (cur = root; cur != NULL; cur = cur->next) { // 搜索兄弟节点
        if (!xmlStrcmp(cur->content, content)) {
            return cur;
        } else {
            xmlNodePtr node = find_node(cur->children, content); // 搜索子节点
            if (node != NULL)
                return node;
        }
    }
    return NULL;
}

void add_to_symboltable(char *token, int code, int id) {
    if (g_symdoc == NULL) {
        perror("add_to_symboltable\n");
        return;
    }

    xmlNodePtr node = xmlNewNode(NULL, BAD_CAST ("symbol"));
    xmlNodePtr content = xmlNewText(BAD_CAST (token));

    if (code == $IDENTIFIER) {
        xmlSetProp(node, BAD_CAST ("attr"), BAD_CAST ("identifier"));
    } else if (code == $CONSTANT) {
        xmlSetProp(node, BAD_CAST ("attr"), BAD_CAST ("constant"));
    }

    char _id[4];
    sprintf(_id, "%d", id);
    xmlSetProp(node, BAD_CAST ("id"), BAD_CAST (_id));

    xmlAddChild(node, content);
    xmlAddChild(g_symroot, node);
}

void add_binary_formula(int code, int id) {
    xmlNodePtr token_node = NULL;
    xmlNodePtr code_node = NULL;
    xmlNodePtr code_content = NULL;
    xmlNodePtr id_node = NULL;
    xmlNodePtr id_content = NULL;
    char s[4];

    if (g_bindoc == NULL || g_symdoc == NULL) {
        perror("add_binary_formula");
        return;
    }

    /* <token> */
    token_node = xmlNewNode(NULL, BAD_CAST ("token"));

    /* <code> */
    code_node = xmlNewNode(NULL, BAD_CAST ("code"));
    sprintf(s, "%d", code);
    code_content = xmlNewText(BAD_CAST (s));
    xmlAddChild(code_node, code_content);
    xmlAddChild(token_node, code_node);

    /* <id> */
    id_node = xmlNewNode(NULL, BAD_CAST ("id"));
    sprintf(s, "%d", id);
    id_content = xmlNewText(BAD_CAST (s));
    xmlAddChild(id_node, id_content);
    xmlAddChild(token_node, id_node);

    switch (code) {
        case $IDENTIFIER:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("identifier"));
            break;
        case $CONSTANT:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("constant"));
            break;
        case $INT:
        case $VOID:
        case $IF:
        case $ELSE:
        case $WHILE:
        case $FOR:
        case $RETURN:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("keyword"));
            break;
        case $ADD:
        case $SUB:
        case $MUL:
        case $DIV:
        case $L:
        case $LE:
        case $G:
        case $GE:
        case $NE:
        case $E:
        case $ASSIGN:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("operator"));
            break;
        case $LPAR:
        case $RPAR:
        case $LBRA:
        case $RBRA:
        case $COM:
        case $SEM:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("delimiter"));
            break;
    }

    xmlAddChild(g_binroot, token_node);
}

void save_xml_file() {
    if (g_bindoc != NULL && g_symdoc != NULL) {
        if (xmlSaveFile(BIN_FILE, g_bindoc) != -1 &&
            xmlSaveFile(SYM_FILE, g_symdoc) != -1) {
            printf("Lexical information written to \"%s\" and \"%s\" successfully!\n",
                   BIN_FILE, SYM_FILE);
        } else {
            perror("xmlSaveFile");
        }
        xmlFreeDoc(g_bindoc);
        xmlFreeDoc(g_symdoc);
    } else {
        printf("save_xml_file: xmlDoc not created!\n");
    }
}
