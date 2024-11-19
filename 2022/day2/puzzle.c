#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define X 1 // Rock
#define Y 2 // Paper
#define Z 3 // Scissors

#define WIN 6
#define LOST 0
#define DRAW 3

// Selects the correct move based on the option parameter. 
// option = 0 -> we need to lose, 1 -> we need to win, 2 -> we need a draw
char inverse_move(int option, char value){
    char to_return;

    switch (option){
    
    case 0: // We need to lose
        
        if (value == 'A'){
            to_return = 'Z';
        }else if (value == 'B'){
            to_return = 'X';
        }else{
            to_return = 'Y';
        }

        break;
    
    case 1: // We need to win

        if (value == 'A'){
            to_return = 'Y';
        }else if (value == 'B'){
            to_return = 'Z';
        }else{
            to_return = 'X';
        }

        break;

    case 2: // We need a draw
        if (value == 'A'){
            to_return = 'X';
        }else if (value == 'B'){
            to_return = 'Y';
        }else{
            to_return = 'Z';
        }

        break;

    default:
        printf("Error: Invalid value %c", value);
        exit(3);
    }

    return to_return;
}

// Calculates the result for each round
int calculate_score(char * line) {
    char opponent = line[0];

    int my_score = 0;
    char me = line[2];

    switch (me){
        case 'X':
            my_score += X;
            break;

        case 'Y':
            my_score += Y;
            break;

        case 'Z':
            my_score += Z;
            break;
    }

    if ( (opponent == 'A' && me == 'Z') || (opponent == 'B' && me == 'X') || (opponent == 'C' && me == 'Y')){ // We lose
        my_score += LOST;

    }else if ( (opponent == 'C' && me == 'X') || (opponent == 'A' && me == 'Y') || (opponent == 'B' && me == 'Z')){ // We win
        my_score += WIN;

    }else{ // Draw
        my_score += DRAW;

    }

    return my_score;
}

// Selects the value we need to obtain a certain end result, and returns the calculated result
int select_value(char* line){
    char opponent = line[0];

    int my_score = 0;
    char me = line[2];
    int option = -1;

    switch (me){
        case 'X':
            option = 0;
            break;

        case 'Y':
            option = 2;
            break;

        case 'Z':
            option = 1;
            break;
    }

    me = inverse_move(option, opponent);

    switch (me){
        case 'X':
            my_score += X;
            break;

        case 'Y':
            my_score += Y;
            break;

        case 'Z':
            my_score += Z;
            break;
    }
    
    if ( (opponent == 'A' && me == 'Z') || (opponent == 'B' && me == 'X') || (opponent == 'C' && me == 'Y')){ // We lose
        my_score += LOST;

    }else if ( (opponent == 'C' && me == 'X') || (opponent == 'A' && me == 'Y') || (opponent == 'B' && me == 'Z')){ // We win
        my_score += WIN;

    }else{ // Draw
        my_score += DRAW;

    }

    return my_score;
}



int main(int argc, char ** argv) {

    if (argc == 1) {
        printf("Error: Need a input file!\n");
        printf("USAGE: ./puzzle <input_file>\n");
        return 1;
    }

    FILE * file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Error: Failed to open file.\n");
        return 2;
    }

    char * line = NULL;
    size_t len = 0;
    int part1_result = 0;
    int part2_result = 0;

    while (getline( & line, & len, file) != -1) {
        part1_result += calculate_score(line);
        part2_result += select_value(line);
    }
    
    printf("[PART 1] My score was: %d\n", part1_result);
    printf("[PART 2] My score was: %d\n", part2_result);

    return 0;
}