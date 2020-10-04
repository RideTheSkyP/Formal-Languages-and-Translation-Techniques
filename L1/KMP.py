import sys

# Knuth–Morris–Pratt algorithm


def createTable(pattern):
    patternLength = len(pattern)
    table = [0] * patternLength
    pos = table[0] = -1

    for i in range(patternLength):
        while (pos > -1) and (pattern[pos] is not pattern[i - 1]):
            pos = table[pos]

        pos += 1

        if (i is patternLength) or (pattern[i] is not pattern[pos]):
            table[i] = pos
        else:
            table[i] = table[pos]

    return table


def kmpSearch(text, pattern):
    table = createTable(pattern)
    pos = 0

    for i in range(len(text)):
        while (pos > -1) and (pattern[pos] is not text[i]):
            pos = table[pos]

        pos += 1

        if pos is len(pattern):
            return i - len(pattern) + 1
    return -1


pattern = sys.argv[1]
text = sys.argv[2]
position, counter = 0, 0
lowered = ""

while True:
    position = kmpSearch(text, pattern)

    if position == -1:
        break

    print(f"Pattern starts at position: {position if position is counter else counter}\nHere is visualization of found pattern in text: {(lowered + text[:position]).lower() + text[position:position+len(pattern)] + text[position + len(pattern):].lower()}\n")
    lowered += text[position + 1]
    text = text[position + 1:]
    counter += 1

