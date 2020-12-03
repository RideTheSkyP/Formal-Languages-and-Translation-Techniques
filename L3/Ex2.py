import math

from sly import Lexer, Parser

BASE = 1234577


class CalcLexer(Lexer):
	tokens = {NAME, NUMBER, ADD, MUL, SUB, DIV, POWER, ASSIGN, LPAREN, RPAREN}
	ignore = " \t"

	# Tokens
	NAME = r"[a-zA-Z_][a-zA-Z0-9_]*"
	NUMBER = r"\d+"

	# Special symbols
	ADD = r"\+"
	SUB = r"-"
	MUL = r"\*"
	DIV = r"/"
	POWER = r"\^"
	ASSIGN = r"="
	LPAREN = r"\("
	RPAREN = r"\)"

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
		self.names = {}

	@_("NAME ASSIGN expr")
	def statement(self, p):
		self.names[p.NAME] = p.expr

	@_("expr")
	def statement(self, p):
		print(f"= {p.expr % BASE}")

	@_("expr ADD expr")
	def expr(self, p):
		return p.expr0 + p.expr1

	@_("expr SUB expr")
	def expr(self, p):
		return p.expr0 - p.expr1

	@_("expr MUL expr")
	def expr(self, p):
		return p.expr0 * p.expr1

	@_("expr DIV expr")
	def expr(self, p):
		return modDivide(p.expr0, p.expr1)

	@_("expr POWER expr")
	def expr(self, p):
		return p.expr0 ** p.expr1

	@_("SUB expr %prec USUB")
	def expr(self, p):
		return -p.expr % BASE

	@_("LPAREN expr RPAREN")
	def expr(self, p):
		return p.expr

	@_("NUMBER")
	def expr(self, p):
		return int(p.NUMBER) % BASE

	@_("NAME")
	def expr(self, p):
		try:
			return self.names[p.NAME]
		except LookupError:
			print(f"Undefined name {p.NAME!r}")
			return 0


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
	while True:
		try:
			text = input("calc > ")
		except EOFError:
			break
		if text:
			parser.parse(lexer.tokenize(text))
