from argparse import ArgumentParser
import sys

class speed_calculator():
    def __init__(self, max_time:int, held_time:int) -> None:
        self.starting_speed = held_time
        self.driven_length = max_time * held_time

    def get_length(self) -> int:
        return self.driven_length


        
def main(file_to_read:str) -> None:
    gut = open(file_to_read).readlines()
    times = [int( x.rstrip() ) for x in gut[0].split(" ") if x.rstrip().isdigit()]
    distance = [int( x.rstrip() ) for x in gut[1].split(" ") if x.rstrip().isdigit()]
    part_1_sum = 1
    winning_tactics = {}

    for x, time in enumerate(times):
        lap_winners = []
        for i in range(0, time+1):
            length = speed_calculator(max_time=time - i, held_time=i).get_length()

            if length > distance[x]:
                lap_winners.append(length)

        winning_tactics[time] = lap_winners

    for race_result in winning_tactics.values():
        part_1_sum *= len(race_result)

    print(f"Part 1: {part_1_sum}")

    # Calculate part 2
    time = int("".join(str(x) for x in times))
    distance = int("".join(str(x) for x in distance))
    part_2_sum = 0

    for i in range(14, time+1):
        length = speed_calculator(max_time=time - i, held_time=i).get_length()
        
        if length > distance:
           part_2_sum  += 1

    print(f"Part 2: {part_2_sum}")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--file", "-f", required=True, help="File to read")

    parsed = parser.parse_args()

    main(parsed.file)
