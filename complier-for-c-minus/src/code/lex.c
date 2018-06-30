
#include <stdio.h>
#include <string.h>
#include "lex.h"

#define _DEBUG_

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

/**
 * 符号表
 */
SYMBOL* sym_tab[HASHSIZE];


//////////////////////////////// PRIVATE ////////////////////////////////

int hash(char* s) {
	int hv = 0;
	
	for(int i = 0; s[i]; i++) {
		int v = (hv >> 28) ^ (s[i] & 0xf);
		hv = (hv << 4) | v;
	}
	
	hv = hv & 0x7fffffff;	 /* Ensure positive */
	return (hv % HASHSIZE);
}


int put_symbol(SYMBOL* sym) {
	int hv = hash(sym->text);

	/* find a free slot in `sym_tab` */
	int i;
	for (i = 0; i < HASHSIZE; i++) {
		if (sym_tab[hv] != NULL) {
#ifdef _DEBUG_
			printf("put_symbol: hash conflict at (%d) when accessing \"%s\", previous text is \"%s\"\n",
				 hv, sym->text, sym_tab[hv]->text);
#endif // _DEBUG_
			hv = (hv + 1) % HASHSIZE;
		}
		else {
			break; /* a free slot is found */
		}
	}
	
	if (i >= HASHSIZE) {
		/* no free slots can be used */
		printf("put_symbol error\n");
		return NONE;
	}
	
	sym_tab[hv] = sym;
	return hv;
}

SYMBOL* get_symbol() {
	SYMBOL* sym = (SYMBOL*)malloc(sizeof(SYMBOL));
	
	return sym; /* We don't check return value of `malloc` */
}

void display_symtab() {
	printf("\n +++++ sym_tab +++++\n");
	
	for (int i = 0; i < HASHSIZE; i++) {
		if (sym_tab[i] != NULL) {
			printf("\t[%d]\n", i);
			
			printf("\tcode = %d, ",	sym_tab[i]->code);
			if (sym_tab[i]->code == $IDENTIFIER)
				printf("(identifier)\n\tname = %s\n", sym_tab[i]->text);
			else if (sym_tab[i]->code == $CONSTANT)
				printf("(constant)\n\tval = %d\n", sym_tab[i]->val);
			else
				printf("(unknown)\n");
		}
	}
}

void clean_up() {
	/* clean `sym_tab` */
	int c = 0;
	for (int i = 0; i < HASHSIZE; i++) {
		if (sym_tab[i] != NULL) {
			free(sym_tab[i]);
			c++;
		}
	}
#ifdef _DEBUG_
	printf("clean_up log : %d slots in `sym_tab`\n", c);
#endif // _DEBUG_
}

//////////////////////////////// PUBLIC ////////////////////////////////

void create_lexical_xml_file() {
    g_bindoc = xmlNewDoc(BAD_CAST "1.0");
    g_binroot = xmlNewNode(NULL, BAD_CAST "bin_table");
    xmlDocSetRootElement(g_bindoc, g_binroot);

    g_symdoc = xmlNewDoc(BAD_CAST "1.0");
    g_symroot = xmlNewNode(NULL, BAD_CAST "sym_table");
    xmlDocSetRootElement(g_symdoc, g_symroot);
}

int find_symbol(char* token) {
	int hv = hash(token);
	
	for (int i = 0; i < HASHSIZE; i++) {
		if (sym_tab[hv] != NULL) {
			if (!strcmp(sym_tab[hv]->text, token)) {
				return hv; /* found */
			}
#ifdef _DEBUG_
			printf("find_symbol: hash conflict at (%d) when accessing \"%s\", previous text is \"%s\"\n",
				 hv, token, sym_tab[hv]->text);
#endif // _DEBUG_
			hv = (hv + 1) % HASHSIZE; /* next slot */ 
		}
	}
	return NONE; /* not found */
}

xmlNodePtr find_node(xmlNodePtr root, xmlChar *content) {
    if (root == NULL)
        return NULL;

    xmlNodePtr cur;
    for (cur = root; cur != NULL; cur = cur->next) { /* 搜索兄弟节点 */
        if (!xmlStrcmp(cur->content, content)) {
            return cur;
        } else {
            xmlNodePtr node = find_node(cur->children, content); /* 搜索子节点 */
            if (node != NULL)
                return node;
        }
    }
    return NULL;
}

int add_to_symboltable(char *token, int code) {
	int id;
	char ids[4]; /* literal text of `id` */
	
    if (g_symdoc == NULL) {
        printf("add_to_symboltable error\n");
        return NONE;
    }

	/* create xml node */
    xmlNodePtr node = xmlNewNode(NULL, BAD_CAST ("symbol"));
    xmlNodePtr content = xmlNewText(BAD_CAST (token));

	/* create node which will be put into `sym_tab` */    
    SYMBOL* sym = get_symbol();
    sym->code = code;

    if (code == $IDENTIFIER) {
        xmlSetProp(node, BAD_CAST ("attr"), BAD_CAST ("identifier"));
    }
    else if (code == $CONSTANT) {
        xmlSetProp(node, BAD_CAST ("attr"), BAD_CAST ("constant"));
        sym->val = atoi(token);
    }
    strncpy(sym->text, token, MAX_NAME);
    
    id = put_symbol(sym);
    if (id == NONE) {
    	printf("add_to_symboltable error\n");
    	return NONE;
    }

    sprintf(ids, "%d", id);
    xmlSetProp(node, BAD_CAST ("id"), BAD_CAST (ids));

    xmlAddChild(node, content);
    xmlAddChild(g_symroot, node);
    
    return id;
}

void add_binary_formula(int code, int id) {
    xmlNodePtr token_node = NULL;
    xmlNodePtr code_node = NULL;
    xmlNodePtr code_content = NULL;
    xmlNodePtr id_node = NULL;
    xmlNodePtr id_content = NULL;
    char s[4];

    if (g_bindoc == NULL || g_symdoc == NULL ||
    	((code == $IDENTIFIER || code == $CONSTANT) && id == NONE)) {
        printf("add_binary_formula error\n");
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
        case $BOOL:
        case $_TRUE:
        case $_FALSE:
        case $IF:
        case $ELSE:
        case $WHILE:
        case $BREAK:
        case $RETURN:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("keyword"));
            break;
        case $ADD:
        case $SUB:
        case $MUL:
        case $DIV:
        case $MOD:
        case $BIT_OR:
        case $BIT_AND:
        case $NOT:
        case $L:
        case $LE:
        case $G:
        case $GE:
        case $NE:
        case $E:
        case $ASSIGN:
        case $ADD_ASSIGN:
        case $SUB_ASSIGN:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("operator"));
            break;
        case $LPAR:
        case $RPAR:
        case $LBRA:
        case $RBRA:
        case $LSBRA:
        case $RSBRA:
        case $COM:
        case $SEM:
            xmlSetProp(token_node, BAD_CAST ("attr"), BAD_CAST ("delimiter"));
            break;
    }

    xmlAddChild(g_binroot, token_node);
}

void save_lexical_xml_file() {
    if (g_bindoc != NULL && g_symdoc != NULL) {
        if (xmlSaveFile(BIN_FILE, g_bindoc) != -1 &&
            xmlSaveFile(SYM_FILE, g_symdoc) != -1) {
            printf("Lexical information written to \"%s\" and \"%s\" successfully!\n",
                   BIN_FILE, SYM_FILE);
        } else {
            printf("xmlSaveFile error\n");
        }
        xmlFreeDoc(g_bindoc);
        xmlFreeDoc(g_symdoc);
    } else {
        printf("save_xml_file error: xmlDoc not created!\n");
    }

#ifdef _DEBUG_
	display_symtab();
#endif // _DEBUG_
    clean_up();
}


