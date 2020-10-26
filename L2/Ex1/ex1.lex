%{
	int lines = 0;
	int words = 0;
%}

%%
^[ ]+	{fprintf(yyout, "");}
[ ]+$	{fprintf(yyout, "");}
[ \t]+	{fprintf(yyout, " "); ++words;}
[\n]+	{fprintf(yyout, "\n"); ++lines; ++words;}
. 		{fprintf(yyout, "%s", yytext);}
end 	return 0;
%%

int yywrap(){};

int main(){
	extern FILE *yyin, *yyout;
	yyin = fopen("testInput.txt", "r");
	yyout = fopen("testOutput.txt", "w");
	yylex();
	printf("Number of lines: %d. Number of words: %d.\n", lines, words);
	return 0;
}
