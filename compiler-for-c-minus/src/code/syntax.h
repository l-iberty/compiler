#ifndef SYNTAX_H
#define SYNTAX_H

#include <libxml/parser.h>
#include <libxml/tree.h>

#define SYNTAX_TREE_FILE	"syntax_tree.xml"

void create_syntax_xml_file();

void save_syntax_xml_file();

void add_children(xmlNodePtr parent, int num, ...);

xmlNodePtr create_terminal_node(char* node_text, char* tag_name);

xmlNodePtr create_nonterminal_node(char* node_text);


#endif // SYNTAX_H

