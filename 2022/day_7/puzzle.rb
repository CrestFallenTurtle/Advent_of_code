
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

$gut = []
# Read the conents of the file
File.readlines(@file_name).each do |line|
    $gut.push(line) # Save it in guts
end

$folders = Hash.new
$folders["/"] = 0
$current_folder = "/"
$current_size = 0 # The current folders size


def grab_parent(path)
    path = path.chop() # Removes the trailing /
    i = 0
    k = 0

    while(k < path.length)
        if path[k] == "/"
            i = k
        end
        k += 1
    end
    
    path = path[0...i] # Keep everything that is before our /

    if !path.end_with?("/")
        path += "/"
    end

    return path
end


def main()
    $gut.each do |line|
        line = line.split(" ")

        if line.first == "$" # Command
            if line.include?("cd") # Change directory

                $folders[$current_folder] = $current_size # insert the old value, before we enter a new folder

                if line.last == "/" # Jump to root
                    $current_folder = "/"

                elsif line.last == ".." # Jump one folder up
                    $current_folder = grab_parent($current_folder)

                else # Jump one folder down into this shit show
                    $current_folder = "#{$current_folder}#{line.last}/"

                end

                $current_size = $folders[$current_folder] # Grab the value

            elsif line.include?("ls") # List directory contents
                # Do nothing
            end
        
        else # This is gonna be the result from 'ls' being executed
            if line.include?("dir") # Ding ding ding, we got a new folder!
                $folders["#{$current_folder}#{line.last}/"] = 0
            else
                $current_size += Integer(line.first) # Add the size of the file
                $folders[$current_folder] += Integer(line.first)

                local_directory = $current_folder
                folder_parent = ""

                while (folder_parent != "/")
                    folder_parent = grab_parent(local_directory)
                    $folders[folder_parent] += Integer(line.first)
                    local_directory = folder_parent
                end
                
            end
        end
    end
end

main() # This will grab all folders and sizes

sum = 0 # First part sum

$folders.keys().each do |folder|
    if $folders[folder] <= 100000
        sum += $folders[folder]
    end
end
puts "[PART 1] Sum was #{String(sum)}"


total_space = 70000000
needed_space = 30000000 - (total_space - $folders["/"])


possible_choices = Hash.new

$folders.keys().each do |folder|
    if ($folders[folder] >= needed_space)
        possible_choices[folder] = $folders[folder] 
    end

end
possible_choices = possible_choices.sort_by(&:last).to_h

puts "[PART 2] The best folder to delete was #{possible_choices.keys.first}, #{$folders[possible_choices.keys.first]}"