class Node
    def initialize(name)
        @name = name
    end

    def set_left(left)
        @left = left
    end

    def set_right(right)
        @right = right
    end

    def get_name()
        return @name
    end

    def get_left()
        return @left
    end

    def get_right()
        return @right
    end

    def details()
        p "name: #{get_name()}"
        p "left: #{get_left().get_name()}"
        p "left: #{get_right().get_name()}"
    end

 end

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

$direction = $gut[0].strip
$node_start = $gut.drop(1)
$nodes = []
$node_neighbors = Hash.new

# Generate nodes
for node in $node_start do
    projects = /(?<name>[A-Z]+) = \((?<left>[A-Z]+), (?<right>[A-Z]+)\)/.match(node)

    if  projects
        name = projects["name"]
        left = projects["left"]
        right = projects["right"]

        node_object = Node.new(name)
        $nodes.append(node_object)
        $node_neighbors[name] = [left, right]
    end
end

# Link the nodes up
for node in $nodes do
    neighbors = $node_neighbors[node.get_name()]

    if node.get_name() == "AAA" # Grab our starting node
        $current_node = node
    end
    
    for node_2 in $nodes do
        # Find the left one
        if node_2.get_name() == neighbors[0]
            node.set_left(node_2)
        end
        
        # Find the right one
        if node_2.get_name() == neighbors[1]
            node.set_right(node_2)
        end

    end
end


$steps = 0
$pointer = 0

# Time to go for a walk
while $current_node.get_name() != "ZZZ"

    if $direction[$pointer] == "L"
        $current_node = $current_node.get_left()

    else
        $current_node = $current_node.get_right()
    end


    $steps += 1
    $pointer += 1

    if $pointer >= $direction.length
        $pointer = 0
    end

end

puts "Part 1: #{$steps}"