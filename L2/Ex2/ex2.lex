%%
#(.*)					{fprintf(yyout, "");}
\"\"\"(.*\n)*.*\"\"\"	{fprintf(yyout, "");}
. 						{fprintf(yyout, "%s", yytext);}
end 					return 0;
%%

int yywrap(){};

int main(){
	extern FILE *yyin, *yyout;
	yyin = fopen("testInput.py", "r");
	yyout = fopen("testOutput.py", "w");
	yylex();
	return 0;
}
