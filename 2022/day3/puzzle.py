from sys import argv, exit
from string import ascii_letters

def main() -> None:
    if len(argv) == 1:
        exit("Error: Needs input file\nUsage: python3 puzzle.py <input_file>")

    alpha_dict = dict([(value, key) for key, value in dict(enumerate(ascii_letters, 1)).items()])

    current_file = argv[1]
    first_part_sum = 0
    second_part_sum = 0
    latest_three_lines = []
    
    for line in open(current_file, "r").readlines():
        first_part = line[0:len(line)//2]
        second_part = line[len(line)//2:]

        # Part 1
        for char in first_part:
            if second_part.find(char) != -1:
                first_part_sum += alpha_dict[char]
                break
        
        # Part 2
        latest_three_lines.append(line)

        if len(latest_three_lines) == 3:
            for char in latest_three_lines[0]:
                if latest_three_lines[1].find(char) != -1 and latest_three_lines[2].find(char) != -1:
                    second_part_sum += alpha_dict[char]
                    break

            latest_three_lines = []

    print(f"[FIRST]: {first_part_sum}")
    print(f"[SECOND]: {second_part_sum}")

if __name__ == "__main__":
    main()