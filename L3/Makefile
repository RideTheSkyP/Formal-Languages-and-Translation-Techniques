CC = cc
all:
	make flex && make bison && make cc

flex:
	flex lexer.l

bison:
	bison -d parser.y

cc:
	cc lex.yy.c parser.tab.c -lm

clean:
	rm *.out && rm *.tab.* && rm yy.c
