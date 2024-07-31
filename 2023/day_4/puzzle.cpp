#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <regex>
#include <cmath>

const char* REGEX_PATTERN = "Card +(\\d+): +([0-9 ]+) +\\| +([0-9 ]+)";

std::vector<std::string> split_lines(std::string line, std::string delimiter) {
    std::vector<std::string> result;
    size_t pos = 0;
    std::string token;
    
    while ((pos = line.find(delimiter)) != std::string::npos) {
        token = line.substr(0, pos);
        
        if (!token.empty()) {
            result.push_back(token);
        }

        line.erase(0, pos + delimiter.length());
    }

    if (!line.empty()) {
        result.push_back(line);
    }

    return result;
}

int process_card(std::vector<std::string> card) {
    std::string left = card.at(0);
    std::string right = card.at(1);
    int count = 0;
    
    std::vector<std::string> left_split = split_lines(left, " ");

    for (auto left_char:left_split) {
        std::vector<std::string> right_split = split_lines(right, " ");
        
        // The right hand side contains a winning number
        for (auto right_char:right_split){

            if (right_char == left_char) {
                count++;
            }
        }
    }

    return count;
}

int main(int argc, char** argv) {

    if (argc < 2) {
        std::cout << "file input is required" << std::endl;
        return 1;
    }

    std::vector<std::vector<std::string>> gut;
    std::vector<int> scratch_count;
    
    std::ifstream opened_file(argv[1]);

    if (!opened_file.is_open()) {
        std::cout << "failed to open file" << std::endl;
        return 1;
    }

    std::string line;
    std::smatch regex_match;
    std::regex regexp(REGEX_PATTERN);
    int long sum = 0;
    int long scratchcards = 0;

    while (std::getline(opened_file, line)) {
        
        std::regex_search (line , regex_match, regexp);

        std::string game_id = regex_match[1];
        std::vector<std::string> values;
        
        values.push_back(regex_match[2]);
        values.push_back(regex_match[3]);

        gut.push_back(values);
    }

    opened_file.close();

    // Generate scratch count
    for (auto _:gut) {
        scratch_count.push_back(1);
    }

    for (int i = 0; i <  gut.size(); i++){
        int count = process_card(gut[i]);


        if (count - 1 >= 0) {
            sum += pow(2, count-1);
        }

        // Part 2
        for (int repeats = scratch_count[i]; repeats > 0; repeats--){
            int local_i = i + 1;
            int local_count = count;

            while( local_count > 0 ){
                scratch_count[local_i]++;
                local_i++;
                local_count--;
            }
        }

    }

    for (int i=0; i < scratch_count.size(); i++ ){
        scratchcards += scratch_count[i];
    }

    std::cout << "Part 1: " << sum << std::endl;
    std::cout << "Part 2: " << scratchcards << std::endl;

    return 0;
}