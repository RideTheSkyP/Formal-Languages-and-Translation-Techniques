%{
	#include <string.h>
	#include <stdbool.h>
	bool doxygen = false;
%}

com1		"/"{2}[^!](.*)
com2 		"/*"[^*|!]*"*/"

doxcom1		"//!"(.*)
doxcom2		"/**"(.*\n)*.*"*/"
doxcom3		"/*!"(.*\n)*.*"!*/"

%x dox

%%
<INITIAL,dox>{com1}    	{
							if(strncmp(yytext, "///", 3)==0)
							{
							 	if(doxygen)
								{
									fprintf(yyout, "");
								}
								else
								{
									fprintf(yyout, "%s", yytext);
								}
							 }
							 else
							 {
							 	fprintf(yyout, "");
							 }
						}
						
<INITIAL,dox>{com2}		{fprintf(yyout, "");}

<dox>{doxcom1}			{fprintf(yyout, "");}
<dox>{doxcom2}			{fprintf(yyout, "");}
<dox>{doxcom3}			{fprintf(yyout, "");}
. 						{fprintf(yyout, "%s", yytext);}
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
			BEGIN(dox);
		}
	}
	else
	{
		BEGIN(INITIAL);
	}
	yylex();
	return 0;
}
