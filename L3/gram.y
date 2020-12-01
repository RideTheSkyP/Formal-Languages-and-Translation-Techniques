%{
	#include<stdio.h>
	#define BASE 1234577
	#define TRUE 1
	#define FALSE 0
%}

%token NUM
%left ADD SUB
%left MUL DIV
%precedence NEGATIVE
%right POW

%%
S:  E {printf("\n= %d\n", mod($1));}
    | {printf("\n");}
    ;
E:  E ADD E { printf("+ ");  $$ = ($1 + $3); }
    |   E MUL E {printf("* "); $$ = ($1 * $3); }
    |   E SUB E {printf("- "); $$ = ($1 - $3); }

    |   SUB NE %prec NEGATIVE { $$ = -$2; }
    |   NUM     { printf("%d ",  mod(yylval)); $$ = $1; }
    |   '(' E ')' { $$ = $2; }
    ;

NE: NUM { printf("%d ", mod((-1) * yylval));  $$ = $1; }
%%


int mod(int a) 
{
    while(a < 0) 
    {
	a += BASE;
    }
    return a % BASE;
}


int yyerror (char *msg) 
{
    printf ("Error");
    return 0;
}

int main()
{
    while(TRUE) 
    {
        yyparse();
    }
}
