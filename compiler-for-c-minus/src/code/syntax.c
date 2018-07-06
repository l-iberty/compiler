#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "syntax.h"

/**
 * 语法树文件
 */
xmlDocPtr g_syntax_tree_doc = NULL;


void create_syntax_xml_file()
{
	g_syntax_tree_doc = xmlNewDoc(BAD_CAST ("1.0"));
}

void save_syntax_xml_file()
{
	if (g_syntax_tree_doc != NULL)
	{
		xmlSaveFile(SYNTAX_TREE_FILE, g_syntax_tree_doc);
		printf("Syntaxical information saved to \"%s\" successfully!\n", SYNTAX_TREE_FILE);
	}
	else
	{
		perror("save_syntax_xml_file");
	}
}

void add_children(xmlNodePtr parent, int num, ...)
{
	va_list arg;
	
	va_start(arg, num);
	
	for (int i = 0; i < num; i++)
	{
		xmlNodePtr child = va_arg(arg, xmlNodePtr);
		xmlAddChild(parent, child);
	}
	
	va_end(arg);
}

xmlNodePtr create_terminal_node(char* node_text, char* tag_name)
{
	xmlNodePtr tag = xmlNewNode(NULL, BAD_CAST (tag_name));
	xmlNodePtr text = xmlNewText(BAD_CAST (node_text));
	xmlAddChild(tag, text);
	return tag;
}

xmlNodePtr create_nonterminal_node(char* node_text)
{
	return xmlNewNode(NULL, BAD_CAST (node_text));
}

