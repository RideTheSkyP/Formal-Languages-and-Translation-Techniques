%{
	#include "gram.tab.h"
	extern int yylval;
%}

COMMENT 	^#.*(\\\n)*.*\n

%%
{COMMENT}   	;
[0-9]+ 	{ yylval=atoi(yytext); return NUM; }
"+"		{return ADD;}
"-"		{return SUB;}
"*"		{return MUL;}
"/"		{return DIV;}
"^"		{return POW;}
\n      	return EOF;
.       	return *yytext;
%%

int yywrap()
{
    return 1;
}
