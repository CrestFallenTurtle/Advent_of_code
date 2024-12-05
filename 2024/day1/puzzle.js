const fs = require("fs")

function main(){
    
    if (process.argv.length === 2){
        console.log("Error: Need an input file to work!")
        process.exit()
    }
    
    let file = process.argv[2]

    try{
        let data = fs.readFileSync(file, "UTF-8")
        let lines = data.split("\n")
        let left_columns = []
        let right_columns = []
        let split_line = []
        let part_1_value = 0
        let part_2_value = 0

        lines.forEach(line  =>{
            split_line = line.split(" ") // Splits the current line

            let first_value = split_line[0]
            let last_value = split_line[split_line.length-1]
            
            left_columns.push(Number(first_value))
            right_columns.push(Number(last_value))

            
        })
        let size = left_columns.length

        // Calculate part 2, calculate the total amount of times that the numbers appear
        for (let index = 0; index < size; index++) {
            let left = left_columns.at(index)

            let total_amount_of_times = right_columns.filter(item => item == left);
            part_2_value += left * total_amount_of_times.length
        }


        // Calculate part 1, start by sorting small to large
        left_columns = left_columns.sort(function (a, b) {  return a - b;  });
        right_columns = right_columns.sort(function (a, b) {  return a - b;  });


        for (let index = 0; index < size; index++) {
            let left = left_columns.pop();
            let right = right_columns.pop();

            part_1_value += Math.abs(left - right)
        }

        console.log("Part 1: "+part_1_value);
        console.log("Part 2: "+part_2_value);

    }catch (err){
        console.log(err)
    }
}


if (require.main == module){ // Checks if it's the current module
    main();
}