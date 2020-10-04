import sys

# Finite Automata algorithm for Pattern Searching

alphabet = 255


def getNextState(pattern, patternLength, state, char):

    if state < patternLength and char == ord(pattern[state]):
        return state + 1

    for nextState in range(state, 0, -1):
        if ord(pattern[nextState - 1]) == char:
            for i in range(nextState - 1):
                if pattern[i] != pattern[state - nextState + 1 + i]:
                    break
                i += 1

                if i == nextState - 1:
                    return nextState
    return 0


def createTable(pattern, patternLength):
    table = [[0 for _ in range(alphabet)] for _ in range(patternLength + 1)]

    for state in range(patternLength + 1):
        for char in range(alphabet):
            table[state][char] = getNextState(pattern, patternLength, state, char)

    return table


def faSearch(text, pattern):
    table = createTable(pattern, len(pattern))
    state = 0

    for i in range(len(text)):
        state = table[state][ord(text[i])]
        if state == len(pattern):
            position = i - len(pattern) + 1
            print(f"Pattern starts at position: {position}\nHere is visualization of found pattern in text: {text[:position].lower() + text[position:position + len(pattern)] + text[position:].lower()}")


text = sys.argv[2]
pattern = sys.argv[1]
faSearch(text, pattern)
