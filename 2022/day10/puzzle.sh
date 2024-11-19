#!/bin/bash

if [[ $# -lt 1 ]]
then
    echo "Error: Needs input file"
    echo "Usage: bash puzzle.sh <input_file>"
    exit 1
fi

file_name=$1

if [[ ! -f $file_name ]]
then
    echo "Error: Failed to find file $file_name"
    exit 1
fi

# Declaration field
cycle=0
x=1
part_1_sum=0

columns=40
curr_line=0
pixel_focus=0 # This will be the current pixel being focused on


# This can work as a count down
cycle () {
    counter=$1
    while [[ counter -gt 0 ]]
    do 
        let cycle=$cycle+1

        # Part 1
        if [[ $cycle -eq 20 || $cycle -eq 60 || $cycle -eq 100 || $cycle -eq 140 || $cycle -eq 180 || $cycle -eq 220 ]]
        then
            signal=$cycle*$x
            let part_1_sum=$part_1_sum+$signal
        fi

        # Part 2
        crt_drawing

    done
}

crt_drawing(){    

    # We are in the visible range
    # The extra 'or' statements makes it represent ### comprated to a single #
    if [[ $x -eq $pixel_focus-1 ||  $x -eq $pixel_focus || $x -eq $pixel_focus+1 ]]
    then
        #matrix[$curr_line, $pixel_focus]="#"
        printf "#"
    else
        printf " "
    fi

    let pixel_focus=$pixel_focus+1 # Maybe move to the beginning of the function? 

    if [[ $pixel_focus -ge $columns ]]
    then
        let line=$curr_line+1
        let pixel_focus=0
        echo "" # Newline
    fi

    let counter=$counter-1
}

# Adds a value to x
addx(){
    cycle 2
    let x=$x+$1
}

# We do nothing here
noop(){
    cycle 1
}

echo -e "[PART 2] CRT Drawing is shown below\n"
while IFS= read -r line; do
    split=( $line )
    command=${split[0]}

    if [[ "$command" == "noop" ]]
    then
        noop
    fi

    if [[ "$command" == "addx" ]]
    then
        addx ${split[1]}
    fi
done < $file_name

echo -e "\n[PART 1] $part_1_sum"
