import argparse


def computeLongestPrefixSuffix(pattern):
    longestPrefixSuffix = [0] * len(pattern)

    prefixPointer = 0
    for index in range(1, len(pattern)):
        while prefixPointer and pattern[index] != pattern[prefixPointer]:
            prefixPointer = longestPrefixSuffix[prefixPointer - 1]

        if pattern[prefixPointer] == pattern[index]:
            prefixPointer += 1
            longestPrefixSuffix[index] = prefixPointer
    return longestPrefixSuffix


def kmpSearch(pattern, text):
    positions = []
    longestPrefixSuffix = computeLongestPrefixSuffix(pattern)

    currentPatternIndex = 0
    for index, character in enumerate(text):
        while currentPatternIndex and pattern[currentPatternIndex] != character:
            currentPatternIndex = longestPrefixSuffix[currentPatternIndex - 1]

        if pattern[currentPatternIndex] == character:
            if currentPatternIndex == len(pattern) - 1:
                positions.append(index - currentPatternIndex)
                currentPatternIndex = longestPrefixSuffix[currentPatternIndex]
            else:
                currentPatternIndex += 1
    return positions


def parseFile(filename):
    with open(filename, "r") as f:
        return "".join(f.readlines())


def main():
    parser = argparse.ArgumentParser(description="Finite Automata")
    parser.add_argument("pattern", help="Pattern we want to find in file.")
    parser.add_argument("filename", help="Filename.")
    args = parser.parse_args()
    print(kmpSearch(args.pattern, parseFile(args.filename)))


if __name__ == "__main__":
    main()
