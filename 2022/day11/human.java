public class human {
    private long stress_level = 0;
    private long monkey_product;

    public human(long monkey_product){
        this.monkey_product = monkey_product;
    }

    // Monkey wants to stress human!
    public void stress_human(String operation, String multiplier, long item_value){
        try {
            
            long i_value = Long.parseLong(multiplier);
            
            switch (operation) {
                case "+":
                    this.stress_level = i_value + item_value;
                    break;

                case "*":
                    this.stress_level = i_value * item_value;
                    break;
            }

        } catch (Exception e) {

            // We need to peform an operation with the already existing value, such as old * old
            switch (operation) {
                case "+":
                    this.stress_level = item_value + item_value;
                    break;

                case "*":
                    this.stress_level = item_value * item_value;
                    break;
            }
        }
    }

    // The monkey have had it's fun with the human
    public long fun_over(boolean first_part){
        if (first_part){
            this.stress_level = (long)Math.floor(this.stress_level/3);
        }else{
            // Returns a postive version of mod
            this.stress_level = tools.calculate_mod(this.stress_level, this.monkey_product);
        }

        return this.stress_level;
    }
}
