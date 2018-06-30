#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

#define SYNTAX_TREE_FILE	"syntax_tree.xml"


xmlDocPtr doc = NULL;

void createXmlFile()
{
	doc = xmlNewDoc(BAD_CAST ("1.0"));
}

void saveXmlFile()
{
	if (doc != NULL)
	{
		xmlSaveFile(SYNTAX_TREE_FILE, doc);
		printf("syntax information successfully saved to %s\n", SYNTAX_TREE_FILE);
	}
	else
	{
		perror("saveXmlFile");
	}
}

void addChild(xmlNodePtr parent, int num, ...)
{
	//printf("[addChild]\n");
	va_list arg;
	
	va_start(arg, num);
	
	for (int i = 0; i < num; i++)
	{
		xmlNodePtr child = va_arg(arg, xmlNodePtr);
		//printf("child: %s, %s\n", child->name, child->content);
		//printf("parent: %s, %s\n", parent->name, parent->content);
		xmlAddChild(parent, child);
	}
	
	va_end(arg);
}

xmlNodePtr createTerminalNode(char* nodeText)
{
	xmlNodePtr tag = xmlNewNode(NULL, BAD_CAST ("T"));
	xmlNodePtr text = xmlNewText(BAD_CAST (nodeText));
	xmlAddChild(tag, text);
	return tag;
}

xmlNodePtr createNonterminalNode(char* nodeText)
{
	return xmlNewNode(NULL, BAD_CAST (nodeText));
}

