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
        let first_columns = [] // The columns related for the first part will be placed here
        let second_columns = [] // The columns related for the second part will be placed here
        let move_instructions = []
        let split_line = []
        let start_of_movement = false

        lines.forEach(line  =>{ // Grab the move instructions
            split_line = line.split(" ") // Splits the current line
            
            if (line === ""){
                start_of_movement = true
            }

            if (split_line.find(element => element === "move") === "move"){ // We found a move instruction
                move_instructions.push(line) // So let's save it
                start_of_movement = true
            }

            if (!start_of_movement){ // Let us read the input data

                split_line.forEach((value, index) =>{
                    if (first_columns[index] === undefined){ // It does not exist yet
                        first_columns[index] = [] // add an empty array
                        second_columns[index] = [] // add an empty array

                    }
                    
                    
                    if (isNaN(value)){ // Insert our value but only if its not a number
                        value = value.split("[")[1].split("]")[0]
                        first_columns[index].push(value)
                        second_columns[index].push(value)
                    }
                })
            }
        })

        // Reverse our columns
        first_columns.forEach((col, index) =>{
            first_columns[index].reverse()
            second_columns[index].reverse()
         })   


        move_instructions.forEach(move =>{
            split_line = move.split(" ") // Splits the current line
            let first_amount = split_line[1]
            let second_amount = split_line[1]

            // To obtain the correct index
            let src = split_line[3]-1 
            let dst = split_line[5]-1 
            
            // First part solution
            while (first_amount > 0) { // Let's fulfill the order
                first_columns[dst].push(first_columns[src].pop()) // The last value of src is put in the dst and is removed from src
                first_amount--
            }

            // Second part solution
            while (second_amount > 0) { // Let's fulfill the order
                if (second_amount > 1){ // Grab more then one box at once
                    let boxes = []

                    while(second_amount > 0){ // Gather all our boxes
                        boxes.push(second_columns[src].pop())
                        second_amount--
                    }

                    boxes.reverse() // Reverse the order of our array

                    boxes.forEach(box =>{ // Move the boxes to it's destination
                        second_columns[dst].push(box)
                    })

                }else{
                    second_columns[dst].push(second_columns[src].pop())
                }
                second_amount--
            }

        })

        let first_part_solution = ""
        first_columns.forEach(col =>{
           first_part_solution += col[col.length-1]
        })

        let second_part_solution = ""
        second_columns.forEach(col =>{
            second_part_solution += col[col.length-1]
        })

        console.log("[FIRST PART] Answer: "+first_part_solution)
        console.log("[SECOND PART] Answer: "+second_part_solution)

    }catch (err){
        console.log(err)
    }


}


if (require.main == module){ // Checks if it's the current module
    main();
}