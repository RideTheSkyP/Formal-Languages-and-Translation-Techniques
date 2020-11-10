%{
	#include <string.h>
	#include <stdbool.h>
	bool doxygen = false;
%}

com1		\n?\/(\\\n)*\/
com2 		\n?\/(\\\n)*\* 

doxcom1 	\n?\/(\\\n)*\*
doxcom2		\*(\\\n)*\/
doxcom3		\n?\/(\\\n)*\/(\/|!)
doxcom4		\n?\/(\\\n)*\*(\\\n)*(\*|!)

%x isstr
%x include
%x singleline
%x multiline

%%

\"                          { fprintf(yyout, "%s", yytext); BEGIN(isstr); }
<isstr>{
\"                          { fprintf(yyout, "%s", yytext); BEGIN(INITIAL); }
.                           fprintf(yyout, "%s", yytext);
}

#include[[:blank:]]*\<      { fprintf(yyout, "%s", yytext); BEGIN(include); }
<include>{
>                           { fprintf(yyout, "%s", yytext); BEGIN(INITIAL); }
.|\n                        fprintf(yyout, "%s", yytext); 
}

{com1}			            BEGIN(singleline);
<singleline>{
.*\\\n                      ;
.                           ;
[^\\]\n                     { fprintf(yyout, "\n"); BEGIN(INITIAL); }
}

{com2}			            BEGIN(multiline);
<multiline>{
.|\n                        ;
{doxcom2}					{ fprintf(yyout, "\n"); BEGIN(INITIAL); }
}

{doxcom3}				    { if (doxygen) BEGIN(singleline); else fprintf(yyout, "%s", yytext); }
{doxcom4}					{ if (doxygen) BEGIN(multiline); else fprintf(yyout, "%s", yytext); }
%%

int yywrap(){};

int main(int argc, char **argv)
{
	extern FILE *yyin, *yyout;
	yyin = fopen("testInput.cpp", "r");
	yyout = fopen("testOutput.cpp", "w");
	if(argc>1)
	{

		if(strcmp(argv[1], "dox") == 0)
		{
			doxygen = true;
		}
	}
	yylex();
	return 0;
}
