from argparse import ArgumentParser
from typing import IO
from os import fsync

def fix_files(src_handler:IO, dst_handler:IO) -> None:
    src_handler.seek(0)
    found = False

    for src in src_handler.readlines():
        src = src.rstrip()
        src = src.split(",")[0]

        for dst in dst_handler.readlines():
            dst = dst.rstrip()
            dst = dst.split(",")[0]

            if src == dst:
                found = True
                break

        if not found:
            dst_handler.write(f"{src},{src}\n")
            dst_handler.flush()
            fsync(dst_handler)
            
            

def find_value(value:str, handler:IO) -> str:
    handler.seek(0)
    to_return = None
    
    for dst in handler.readlines():
        dst = dst.rstrip()
        split = dst.split(",")
       
        if value == split[0]:
            to_return = split[1]
            break

    return to_return

def main(file_to_read:str) -> None:
    seeds = open("seeds.txt", "w+")
    seed_to_soil = open("seed_to_soil.txt", "w+")
    soil_to_fertilizer = open("soil_to_fertilizer.txt", "w+")
    fertilizer_to_water = open("fertilizer_to_water.txt", "w+")
    water_to_light = open("water_to_light.txt", "w+")
    light_to_temperature = open("light_to_temperature.txt", "w+")
    temperature_to_humidity = open("temperature_to_humidity.txt", "w+")
    humidity_to_location = open("humidity_to_location.txt", "w+")

    state = 0
    
    for line in open(file_to_read, "r").readlines():
        split = line.strip().split(" ")

        if split == ['']:
            continue

        if "seeds:" in line:
            for seed in split[1:]:
                seeds.write(f"{seed}\n")
                seeds.flush()
            continue

        match split[0]:
            case "seed-to-soil":
                state = 1
                continue

            case "soil-to-fertilizer":
                state = 2
                continue

            case "fertilizer-to-water":
                state = 3
                continue

            case "water-to-light":
                state = 4
                continue

            case "light-to-temperature":
                state = 5
                continue

            case "temperature-to-humidity":
                state = 6
                continue

            case "humidity-to-location":
                state = 7
                continue
        
        index_range = int(split[2])       
        lower_base = 0

        while lower_base < index_range:
            src = str( int(split[1]) + lower_base )
            dst = str( int(split[0]) + lower_base )
            
            lower_base += 1

            match state:
                case 1:
                    seed_to_soil.write(f"{src},{dst}\n")
                    seed_to_soil.flush()
                    fsync(seed_to_soil)

                case 2:
                    soil_to_fertilizer.write(f"{src},{dst}\n")
                    soil_to_fertilizer.flush()
                    fsync(soil_to_fertilizer)

                case 3:
                    fertilizer_to_water.write(f"{src},{dst}\n")
                    fertilizer_to_water.flush()
                    fsync(fertilizer_to_water)

                case 4:
                    water_to_light.write(f"{src},{dst}\n")
                    water_to_light.flush()
                    fsync(water_to_light)

                case 5:
                    light_to_temperature.write(f"{src},{dst}\n")
                    light_to_temperature.flush()
                    fsync(light_to_temperature)

                case 6:
                    temperature_to_humidity.write(f"{src},{dst}\n")
                    temperature_to_humidity.flush()
                    fsync(temperature_to_humidity)

                case 7:
                    humidity_to_location.write(f"{src},{dst}\n")
                    humidity_to_location.flush()
                    fsync(humidity_to_location)

    fix_files(seeds, seed_to_soil)
    fix_files(seed_to_soil, soil_to_fertilizer)
    fix_files(soil_to_fertilizer, fertilizer_to_water)
    fix_files(fertilizer_to_water, water_to_light)
    fix_files(water_to_light, light_to_temperature)
    fix_files(light_to_temperature, temperature_to_humidity)
    fix_files(temperature_to_humidity, humidity_to_location)

    lowest_location_number = None
    seeds.seek(0)
    for seed in seeds.readlines():      
        seed_to_soil.seek(0)
        seed = seed.rstrip()
        
        soil = find_value(seed, seed_to_soil)
        fertilizer = find_value(soil, soil_to_fertilizer)
        water = find_value(fertilizer, fertilizer_to_water)
        light = find_value(water, water_to_light)
        temperature = find_value(light, light_to_temperature)
        humidty = find_value(temperature, temperature_to_humidity)
        location = find_value(humidty, humidity_to_location)

        #print(seed, soil, fertilizer, water, light, temperature, humidty, location)

        if location and (lowest_location_number == None or lowest_location_number > location):
            lowest_location_number = location

    seeds.close()
    seed_to_soil.close()
    soil_to_fertilizer.close()
    fertilizer_to_water.close()
    water_to_light.close()
    light_to_temperature.close()
    temperature_to_humidity.close()
    humidity_to_location.close()

    print(f"Part 1: {lowest_location_number}")

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--file", "-f", required=True, help="File to read")

    parsed = parser.parse_args()

    main(parsed.file)
