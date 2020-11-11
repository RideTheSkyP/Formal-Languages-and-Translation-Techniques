%{
	#include <stdbool.h>
	bool doxygen = false;
%}

com1		\n?\/(\\\n)*\/
com2 		\n?\/(\\\n)*\* 

doxcom1		\*(\\\n)*\/
doxcom2		\n?\/(\\\n)*\/(\/|!)
doxcom3		\n?\/(\\\n)*\*(\\\n)*(\*|!)

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
{doxcom1}					{ fprintf(yyout, "\n"); BEGIN(INITIAL); }
}

{doxcom2}				    { if (doxygen) BEGIN(singleline); else fprintf(yyout, "%s", yytext); }
{doxcom3}					{ if (doxygen) BEGIN(multiline); else fprintf(yyout, "%s", yytext); }
%%

int yywrap(){};

int main(int argc, char **argv)
{
	extern FILE *yyin, *yyout;
	
	if (argc==1)
	{
		printf("Arg 1: Input file(cpp)\nArg 2: Optional. dox - to remove doxygen comments\n");
		return 0;
	}
	
	if(argc>1)
	{
		yyin = fopen(argv[1], "r");
		if (argc>2)
		{
			doxygen = true;
		}
	}
	
	yyout = fopen("output.cpp", "w");
	yylex();
	return 0;
}
