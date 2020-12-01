%{
	#include<stdio.h>
	#define BASE 1234577
	int mod(int x);
	int modDiv(int x, int y);
	int gcdExtended(int x, int y, int *i, int *j);
	int modPow(int x, int y);
	int yyerror(char *msg);
	int yylex();
%}

%token NUM
%left ADD SUB
%left MUL DIV
%right POW
%precedence NEG

%%
line:  
	expr 	{ printf("\n= %d\n", mod($1)); }
	| 	{ printf("\n"); }
    	;
expr:  	expr ADD expr { printf("+ "); $$ = ($1 + $3); }
	|   	expr SUB expr { printf("- "); $$ = ($1 - $3); }
	|   	expr MUL expr { printf("* "); $$ = ($1 * $3); }
	|   	expr DIV expr { printf("/ "); $$ = modDiv($1, $3); }
	|   	expr POW expr { printf("^ "); $$ = modPow($1, $3); }
	|   	SUB negexp %prec NEG { $$ = -$2; }
	|   	NUM	      { printf("%d ", mod(yylval)); $$ = $1; }
	|   	'(' expr ')'  { $$ = $2; }
	;

negexp: 	NUM	      { printf("%d ", mod((-1) * yylval));  $$ = $1; }
%%

int mod(int x)
{
    while(x < 0) 
    {
	x += BASE;
    }
    return x % BASE;
}

int modPow(int x, int y) 
{
	if(x == 0) 
	{
		return 0;
	}
	if(y == 0) 
	{
		return 1;
	}
	int answer = 1;
	while(y--) 
	{
		answer = (answer * x) % BASE;
	}
	return answer;
}

int gcdExtended(int x, int y, int *i, int *j)
{
    if (x == 0)
    {
	*i = 0;
	*j = 1;
	return y;
    }
    
    int i1, j1;
    int gcd = gcdExtended(y%x, x, &i1, &j1);
 
    *i = j1 - (y/x) * i1;
    *j = i1;
 
    return gcd;
}

int modDiv(int x, int y)
{
    int i, j;
    gcdExtended(y, BASE, &i, &j);
    return (int)(((unsigned long int)x * (unsigned long int)mod(i)) % (unsigned long int)BASE);
}

int yyerror(char *msg)
{
	printf("Error");
	return 0;
}

int main(void)
{
	while(1)
	{
		yyparse();
	}
}
