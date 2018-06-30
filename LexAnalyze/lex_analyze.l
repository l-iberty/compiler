%{
	#include "xmlhelper.h"
	int count = 1;
	extern xmlNodePtr g_symroot;
%}

%%

int {   add_binary_formula($INT, NONE);	}

void    {   add_binary_formula($VOID, NONE);    }

if  { add_binary_formula($IF, NONE);  }

else  {   add_binary_formula($ELSE, NONE);    }

while  {  add_binary_formula($WHILE, NONE); }

for  {    add_binary_formula($FOR, NONE); }

return  { add_binary_formula($RETURN, NONE);   }

[A-Za-z]([A-Za-z]|[0-9])*   {   
	add_binary_formula($IDENTIFIER, count);
	
	// 如果没有在 symbol_table 中找到该标识符, 则添加之
	if (!find_node(g_symroot, BAD_CAST(yytext))) {
		add_to_symboltable(yytext, $IDENTIFIER, count++);
	}
}

[0-9]*  {
	add_binary_formula($CONSTANT, count);
	
	// 如果没有在 symbol_table 中找到该标识符, 则添加之
	if (!find_node(g_symroot, BAD_CAST(yytext))) {
		add_to_symboltable(yytext, $CONSTANT, count++);
	}
}

"+"  {  add_binary_formula($ADD, NONE);   }

"-"  {  add_binary_formula($SUB, NONE);   }

"*"  {  add_binary_formula($MUL, NONE);   }

"/"  {  add_binary_formula($DIV, NONE);   }

"<"  {  add_binary_formula($L, NONE); }

"<="  { add_binary_formula($LE, NONE);   }

">"  {  add_binary_formula($G, NONE); }

">="  { add_binary_formula($GE, NONE);   }

"!="  { add_binary_formula($NE, NONE);   }

"=="  { add_binary_formula($E, NONE);    }

"="  {  add_binary_formula($ASSIGN, NONE);    }

"("  {  add_binary_formula($LPAR, NONE);  }

")"  {  add_binary_formula($RPAR, NONE);  }

"{"  {  add_binary_formula($LBRA, NONE);  }

"}"  {  add_binary_formula($RBRA, NONE);  }

","  {  add_binary_formula($COM, NONE);   }

";"  {  add_binary_formula($SEM, NONE);   }

.|\n

%%

#include "xmlhelper.h"

int main(int argc, char *argv[]) 
{
	if (argc != 2)
	{
		printf("Usage: %s <filename>\n", argv[0]);
		return 0;
	}

	yyin = fopen(argv[1], "r");
	if(yyin == NULL)
	{
		printf("error\n");
		return 0;
	}

	create_xml_file();
	yylex();
	save_xml_file();

	fclose(yyin);
	return 0;
}

