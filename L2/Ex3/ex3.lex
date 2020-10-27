%{
%}

com1		"//"[^!](.*)
com2 		"/*"[^*|!]*"*/"

doxcom1		"///"(.*)
doxcom2		"//!"(.*)
doxcom3		"/**"(.*\n)*.*"*/"
doxcom4		"/*!"(.*\n)*.*"!*/"

%x dox

%%
<INITIAL,dox>{com1}    	{fprintf(yyout, "");}
<INITIAL,dox>{com2}		{fprintf(yyout, "");}
<dox>{doxcom1}			{fprintf(yyout, "");}
<dox>{doxcom2}			{fprintf(yyout, "");}
<dox>{doxcom3}			{fprintf(yyout, "");}
<dox>{doxcom4}			{fprintf(yyout, "");}
. 						{fprintf(yyout, "%s", yytext);}
end 					return 0;
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
