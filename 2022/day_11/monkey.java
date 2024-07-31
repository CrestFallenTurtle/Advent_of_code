
import java.util.*;  

public class monkey {
    private long monkey_id = -1;
    private Vector<Long>  held_items = new Vector<Long>();
    private Vector<Long>  held_items_copy = new Vector<Long>();

    private String stress_index = "";
    private String stress_operation = ""; // Multiply, add, sub?
    private int div_index = -1;
    private int true_monkey_id = -1;
    private int false_monkey_id = -1;
    private Vector<monkey> monkeys = new Vector<monkey>(); // All monkeys are placed here
    private human human_player;
    private int times_inspected = 0;

    // Constructor
    public monkey(int monkey_id, Vector<Long> held_items, String stress_index, String stress_operator, int div_index, int true_monkey_id, int false_monkey_id){
        this.monkey_id = monkey_id;

        // Apparrently just assigning the longernal vector with the provided one doesnt update the size of it..
        for (int i = 0; i < held_items.size(); i++){
            this.held_items.add(held_items.elementAt(i));
            this.held_items_copy.add(held_items.elementAt(i));
        }

        this.stress_index = stress_index;
        this.stress_operation = stress_operator;
        this.div_index = div_index;
        this.true_monkey_id = true_monkey_id;
        this.false_monkey_id = false_monkey_id;
    }

    public void add_human(human human_player){
        this.human_player = human_player;
    }

    // Reset thy monkey for part 2
    public void reset(){
        this.held_items.clear();

        for (int i = 0; i < held_items_copy.size(); i++){
            this.held_items.add(held_items_copy.elementAt(i));
        }
        this.times_inspected = 0;
    }

    // This will inform thy monkey that there exist multiple of it's kind
    public void add_monkey(int monkey_id, monkey monkey){
        this.monkeys.add(monkey_id, monkey);
    }


    public void get_item(Long item){
        held_items.add(item); // Fellow brotha is nice today
    }

    public void send_item(int monkey_id, int item_index){
        this.monkeys.elementAt(monkey_id).get_item(held_items.elementAt(item_index).longValue()); // Give brotha monkey new toy
    }

    // Meat of the monkey is here
    public void investigate(boolean first_part){
        for (int i = 0; i < this.held_items.size(); i++){

            this.times_inspected += 1;


            this.human_player.stress_human(this.stress_operation, this.stress_index, this.held_items.elementAt(i).longValue());
            this.held_items.set(i, this.human_player.fun_over(first_part)); // Our item got a new worry level

            int target_monkey = this.false_monkey_id; // Default monkey
            
            if ((this.held_items.elementAt(i).longValue() % this.div_index) == 0){
                target_monkey = this.true_monkey_id;
            }

            this.send_item(target_monkey, i);
        }

        // Delete the inventory
        held_items.clear();

    }

    // Monkey is bad bad and needs to seek god
    public long face_thy_maker(){
        //System.out.printf("[MONKEY %d] Inspected %d items, inventory %s\n",this.monkey_id, this.times_inspected, this.held_items);
        return this.times_inspected;
    }
}