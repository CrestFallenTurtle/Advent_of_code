
import java.io.File;  
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.*;  
import java.util.Collections;

public class puzzle {
    public static void main(String[] args){

        if (args.length < 1){ // No file was provided
            System.out.println("Error: Needs input file");
            System.out.println("Usage: java puzzle <input_file>");
            System.exit(1);
        }

        String file_name = args[0];
        File file = new File(file_name);

        if (!file.exists()){ // File didn't exist
            System.out.println("Error: Failed to find file "+file_name);
            System.exit(1);
        }

        int line_index = 1;
        int monkey_id = -1;
        Vector<Long> held_items = new Vector<Long>(); 
        String stress_index = "";
        String stress_operation = "";
        int div_index = -1;
        int true_monkey_id = -1;
        int false_monkey_id = -1;
        int monkey_product = 1;

        Vector<monkey> monkeys = new Vector<monkey>();

        try {
            Scanner reader = new Scanner(file);
            // Parse the data
            while (reader.hasNextLine()) {
              String data = reader.nextLine();
              String[] split = data.split(" ");

              switch(line_index){
                case 1:
                    monkey_id = Integer.parseInt(split[1].substring(0, 1));
                    break;

                case 2:
                    for (int i=4; i < split.length; i++){
                        held_items.add(Long.parseLong(split[i].replaceAll(",", "")));
                    }
                    break;
                
                case 3:
                    stress_operation = split[split.length-2];
                    stress_index = split[split.length-1];
                    break;

                case 4:
                    div_index = Integer.parseInt(split[split.length-1]);
                    monkey_product *= div_index;
                    break;

                case 5:
                    true_monkey_id = Integer.parseInt(split[split.length-1]);
                    break;

                case 6:
                    false_monkey_id = Integer.parseInt(split[split.length-1]);
                    break;
              }

              if (data.trim().isEmpty()){ // We know it's time to construct a monkey when this becomes true
                monkey new_monkey = new monkey(monkey_id, held_items, stress_index, stress_operation, div_index, true_monkey_id, false_monkey_id);
                monkeys.add(new_monkey);

                held_items.clear();
                line_index = 0;
              }

              line_index++;            
            }

            reader.close();

          } catch (FileNotFoundException e) {
            System.out.println("Error: Failed to read file");
            e.printStackTrace();
          }

          human human_player = new human(monkey_product);


        // Make one great monkey army
        for (int i = 0; i < monkeys.size(); i++){
            for (int x = 0; x < monkeys.size(); x++){
                monkeys.elementAt(i).add_monkey(x, monkeys.elementAt(x));
                monkeys.elementAt(i).add_human(human_player);
            }
        }

        long rounds = 0;
        while (rounds < 20){
        
            for (int i = 0; i < monkeys.size(); i++){
                monkeys.elementAt(i).investigate(true);
            }

            rounds++;
        }

        // Judgement are upon thy hersey monkeys
        Vector<Long> heresy_counter = new Vector<Long>();          
        for (int i = 0; i < monkeys.size(); i++){
            heresy_counter.add(monkeys.elementAt(i).face_thy_maker()); 
        }
        
        // Who thy of the monkeys where the most sinful?
        Collections.sort(heresy_counter); // Sort it from the lowest to the highest possible value
        long monkey_business = heresy_counter.elementAt(heresy_counter.size()-1) * heresy_counter.elementAt(heresy_counter.size()-2); // might be too small?

        System.out.printf("[PART 1] The amount of monkey business was %d\n\n", monkey_business);


        // Part 2
        // Reset the monkeys
        for (int i = 0; i < monkeys.size(); i++){
            monkeys.elementAt(i).reset();
        }

        rounds = 0;
        while (rounds < 10000){
            for (int i = 0; i < monkeys.size(); i++){
                monkeys.elementAt(i).investigate(false);
            }

            rounds++;
        }

        // Judgement are upon thy hersey monkeys
        heresy_counter.clear();          
        for (int i = 0; i < monkeys.size(); i++){
            heresy_counter.add(monkeys.elementAt(i).face_thy_maker()); 
        }
        
        // Who thy of the monkeys where the most sinful?
        Collections.sort(heresy_counter); // Sort it from the lowest to the highest possible value
        monkey_business = heresy_counter.elementAt(heresy_counter.size()-1) * heresy_counter.elementAt(heresy_counter.size()-2); // might be too small?

        System.out.printf("[PART 2] The amount of monkey business was %d\n", monkey_business);
    }
}