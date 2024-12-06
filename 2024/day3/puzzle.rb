if ARGV.length == 0 # Check if any arguments was provided
    puts "Error: Need an input file to work!"
    puts "USAGE: ruby puzzle.rb <file/to/read>"
    exit
end

@file_name = ARGV[0]

# Check if the file existed
if !File.file?(@file_name)
    puts("Error: File '"+@file_name+"' did not exist")
    exit
end

part_1_score = 0
part_2_score = 0
disable_counting = false

REGEX_PART_1 = /mul\(([0-9]{1,3}),([0-9]{1,3})\)/
REGEX_PART_2 = /mul\(([0-9]{1,3}),([0-9]{1,3})\)|(don't\(\))|(do\(\))/

# Read the conents of the file
File.readlines(@file_name).each do |line|
    
    # Part 1
    if match = line.scan(REGEX_PART_1)
        for value_group in match
            value_group_score = 1

            for value in value_group
                value_group_score *= value.to_i
            end

            part_1_score += value_group_score
            
        end
    end

    # Part 2
    if match = line.scan(REGEX_PART_2)
        for value_group in match
            value_group_score = 1
            been_counting = false

            for value in value_group
                unless value.to_s.strip.empty?
                    
                    if value == "don't()"
                        disable_counting = true
                    
                    elsif value == "do()"
                        disable_counting = false
                    
                    elsif !disable_counting
                        value_group_score *= value.to_i
                        been_counting = true

                    end

                end

            end
            
            # No point in calculating if we are not supposed to be counting
            if !disable_counting && been_counting
                part_2_score += value_group_score

            end
        end
    end


end

puts "Part 1: #{part_1_score}"
puts "Part 2: #{part_2_score}"