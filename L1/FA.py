# Finite Automata algorithm for Pattern Searching
import argparse

alphabet = 3000
positions = list()


def getNextState(pattern, patternLength, state, char):
    if state < patternLength and char == ord(pattern[state]):
        return state + 1

    index = 0
    for nextState in range(state, 0, -1):
        if ord(pattern[nextState - 1]) == char:
            for i in range(nextState - 1):
                if pattern[i] != pattern[state - nextState + 1 + i]:
                    break
                index += 1
            if index == nextState - 1:
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
            positions.append(position)


def parseFile(filename):
    with open(filename, "r") as f:
        return "".join(f.readlines())


def main():
    parser = argparse.ArgumentParser(description="Finite Automata")
    parser.add_argument("pattern", help="Pattern we want to find in file.")
    parser.add_argument("filename", help="Filename.")
    args = parser.parse_args()
    faSearch(parseFile(args.filename), args.pattern)
    print(positions)


if __name__ == "__main__":
    main()
