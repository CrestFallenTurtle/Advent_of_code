from argparse import ArgumentParser
import sys

def main(file_to_read:str) -> None:
    total_history = []

    for line in open(file_to_read).readlines():
        history = [int(x.strip()) for x in line.split(" ")]


        line_history = [history]

        # Construct
        while history != [0 for n in range( len(history) )]:
            new_line_result = []
            prev_value = None

            for n in history:
                if prev_value == None:
                    prev_value = n
                else:
                    new_line_result.append ( n - prev_value )
                    prev_value = n

            history = new_line_result
            line_history.append( history )


        line_history.reverse()
        line_history[0].append(0)
        

        prev_value = line_history[0][0]
        for n, line in enumerate(line_history[1:]):
            first_value = line[0]
            diff = first_value - prev_value
            line_history[n+1].insert (0,  diff )
            prev_value = diff
            
        line_history.reverse()

        total_history.append(line_history)
    
    part_2_sum = 0
    for line in total_history:
        part_2_sum += line[0][0]


    print(f"Part 2: {part_2_sum}")
   


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--file", "-f", required=True, help="File to read")

    parsed = parser.parse_args()

    main(parsed.file)