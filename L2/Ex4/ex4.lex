%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<stdbool.h>
	#include<math.h>

	bool error = false;
	int ptr = -1;
	int stack[255];

	void push(int num) 
	{
		ptr++;
		if (ptr < 255) 
		{
		    stack[ptr] = num;
		} 
		else 
		{
		    printf("Stack Overflow");
		} 
	}

	int pop() 
	{
		if (ptr >= 0) 
		{
		    ptr--;
		    return stack[ptr + 1];
		} 
		else 
		{
		    error = true;
		    return 0;
		}
	}
	
	void add()
	{
		push(pop() + pop());
	}
	
	void subtract()
	{
		int x = pop();
		int y = pop();
		push(y - x);
	}
	
	void multiply()
	{
		push(pop() * pop());
	}
	
	void divide(int divisor)
	{
		push(pop()/divisor);
	}
	
	void mod(int divisor)
	{
		push(pop() % divisor);
	}
	
	void power()
	{
		push(pow(pop(), pop()));
	}
	
	void result()
	{
		if(!error)
        {
			if (ptr == 0) 
			{
				printf("= %d\n", pop());
			} 
			else if(ptr > 0 )
			{
				printf("Too few operators\n");
			}
		} 
		else 
		{
			printf("Too few arguments\n");
			error = false;
		}
		ptr = -1;
	}
%}

%x ERROR

%%
-?[0-9]+		push(atoi(yytext));
"+"				{ add(); if(error) BEGIN(ERROR);}
"-"				{ subtract(); if (error) BEGIN(ERROR); }
"*"				{ multiply(); }
"/"         	{	int divisor = pop();
				 	if (divisor == 0) 
				 	{
					 	printf("Division by 0\n");
					 	BEGIN(ERROR);
					} 
					else 
					{
						divide(divisor);
					}
					if (error) BEGIN(ERROR);
				}
"%"         	{
			        int divisor = pop();
			        if (divisor == 0) {
			            printf("Division by 0\n");
			            BEGIN(ERROR);
			        }
			        else 
			        {
			            mod(divisor);
			        }
			        if (error) BEGIN(ERROR);
				}
"^"             power();
\n            	result();
[^[:blank:]]    {printf("This symbol is not allowed: %s\n", yytext); error = true;};
[[:blank:]]     ;

<ERROR>.*       ;
<ERROR>\n       { ptr = -1; error = false; BEGIN(INITIAL); }
%%

int yywrap(){}

int main()
{
    yylex();
    return 0;
}
