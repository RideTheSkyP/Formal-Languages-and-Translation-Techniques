import math
from sly import Lexer, Parser

BASE = 1234577


class CalcLexer(Lexer):
	tokens = {NUMBER, ADD, MUL, SUB, DIV, POWER, ASSIGN, LPAREN, RPAREN}
	ignore = " \t"

	NUMBER = r"\d+"

	ADD = r"\+"
	SUB = r"-"
	MUL = r"\*"
	DIV = r"/"
	POWER = r"\^"
	ASSIGN = r"="
	LPAREN = r"\("
	RPAREN = r"\)"

	ignore_comment = r'\#.*'

	def error(self, t):
		print(f"Illegal character {t.value[0]}")
		self.index += 1


class CalcParser(Parser):
	tokens = CalcLexer.tokens

	precedence = (
		("left", ADD, SUB),
		("left", MUL, DIV),
		("right", POWER),
		("right", USUB),
	)

	def __init__(self):
		self.postfixString = ""

	@_("expr")
	def statement(self, p):
		print(f"{self.postfixString}\n= {p.expr % BASE}")
		self.postfixString = ""

	@_("expr ADD expr")
	def expr(self, p):
		self.postfixString += "+ "
		return p.expr0 + p.expr1

	@_("expr SUB expr")
	def expr(self, p):
		self.postfixString += "- "
		return p.expr0 - p.expr1

	@_("expr MUL expr")
	def expr(self, p):
		self.postfixString += "* "
		return p.expr0 * p.expr1

	@_("expr DIV expr")
	def expr(self, p):
		self.postfixString += "/ "
		return modDivide(p.expr0, p.expr1)

	@_("expr POWER expr")
	def expr(self, p):
		self.postfixString += "^ "
		return p.expr0 ** p.expr1

	@_("SUB expr %prec USUB")
	def expr(self, p):
		words = self.postfixString.split()
		self.postfixString = " ".join(words[:-1])
		self.postfixString += f" {-p.expr % BASE} "
		return -p.expr % BASE

	@_("LPAREN expr RPAREN")
	def expr(self, p):
		return p.expr

	@_("NUMBER")
	def expr(self, p):
		self.postfixString += f"{p.NUMBER} "
		return int(p.NUMBER) % BASE


def modInverse(b):
	g = math.gcd(b, BASE)
	if g != 1:
		return -1
	else:
		return pow(b, BASE - 2, BASE)


def modDivide(a, b):
	a = a % BASE
	inv = modInverse(b)
	if inv == -1:
		print("Division not defined")
	else:
		return (inv * a) % BASE


if __name__ == "__main__":
	lexer = CalcLexer()
	parser = CalcParser()
	text = ""
	while True:
		try:
			text = input("")
		except EOFError:
			print("Error")
		if text:
			parser.parse(lexer.tokenize(text))
