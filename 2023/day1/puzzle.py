from argparse import ArgumentParser
from re import findall


REGEX_PATTERN = "(?=(\d|one|two|three|four|five|six|seven|eight|nine))"

def convert_str_to_int(value:str) -> None:   
    match value:
        case "one":
            to_return = 1

        case "two":
            to_return = 2

        case "three":
            to_return = 3

        case "four":
            to_return = 4

        case "five":
            to_return = 5

        case "six":
            to_return = 6

        case "seven":
            to_return = 7

        case "eight":
            to_return = 8

        case "nine":
            to_return = 9

        case _:
            to_return = value

    return to_return

def calibrator(values:list) -> None:
    value_pot = 0

    for line in values:
        match_object = findall(REGEX_PATTERN, line)
        if match_object:
            first = convert_str_to_int(match_object[0])
            last = convert_str_to_int(match_object[ len(match_object) - 1 ])

            weird_integer = f"{first}{last}"
            value_pot += int(weird_integer)


    print(value_pot)


def main(file:str) -> None:
   content = open(file, "r").readlines()

   calibrator(content)

if __name__ == "__main__":
    parser = ArgumentParser()

    parser.add_argument("--file", "-f", required=True)

    parsed_args = parser.parse_args()


    main(parsed_args.file)