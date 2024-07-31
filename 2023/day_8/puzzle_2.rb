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
$starting_nodes = []

# Generate nodes
for node in $node_start do
    projects = /(?<name>[A-Z0-9]+) = \((?<left>[A-Z0-9]+), (?<right>[A-Z0-9]+)\)/.match(node)

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
    if node.get_name().end_with?("A")  # Grab our starting nodes
        $starting_nodes.append(node)
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



$pointer = 0
$paths = []

# Time to go for a walk
    
for node in $starting_nodes
    $starting_nodes = $starting_nodes.drop(1)
    $steps = 0

    while node.get_name().end_with?("Z") != true
        if $direction[$pointer] == "L"
            node = node.get_left()
        else
            node = node.get_right()
        end
        
        $steps += 1
        $pointer += 1
        if $pointer >= $direction.length
            $pointer = 0
        end

    end

    $paths.append($steps)

    
end

part_2_value = $paths.reduce(1) { |acc, n| acc.lcm(n) }

puts "Part 2: #{part_2_value}"