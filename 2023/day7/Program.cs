namespace day_7;
class Program {
        static readonly IDictionary<string, int> cards_strength = new Dictionary<string, int> {
            { "A", 14 },
            { "K", 13 },
            { "Q", 12 },
            { "J", 11 },
            { "T", 10 },
            { "9", 9 },
            { "8", 8 },
            { "7", 7 },
            { "6", 6 },
            { "5", 5 },
            { "4", 4 },
            { "3", 3 },
            { "2", 2 }
        };

        public struct Card {
            public string str;
            public int value;
            
            public int type;
        }

        enum Combination_worth {
            High,
            One,
            Two,
            Three,
            Full,
            Four,
            Five
        }

    static IDictionary<string, int> parse_line(string line) {
        // populates a dictionary with <char, char_count>
        IDictionary<string, int> character_count = new Dictionary<string, int>{};

        for (var i = 0; i < line.Length; i++) {
            var card_char = line[i].ToString();

            if (!character_count.ContainsKey(card_char)) {
                character_count.Add(card_char, 1);
            } else {
                character_count[card_char]++;
            }
        }

        return character_count;
    }



    static int Identify_kind(string line) {
        int to_return = 0;

        IDictionary<string, int> character_count = parse_line(line);
        List<string> keys = character_count.Keys.ToList();
        int amount_of_keys = keys.Count;

        switch (amount_of_keys) {
            case 1:
                // Five of a kind
                to_return = (int)Combination_worth.Five;
                break;

            case 2:
                // Four of a kind or Full house
                var a = character_count[ keys[0] ];
                var b = character_count[ keys[1] ];

                if ( (a == 4 && b == 1) || (a == 1 && b == 4)) {
                    to_return = (int)Combination_worth.Four;
                } else {
                    to_return = (int)Combination_worth.Full;
                }

                break;

            case 3:
                // Three of a kind or Two pair
                var a3 = character_count[ keys[0] ];
                var b3 = character_count[ keys[1] ];
                var c3 = character_count[ keys[2] ];

                if ((a3 == 3 && b3 == 1 && c3 == 1) || (a3 == 1 && b3 == 3 && c3 == 1) || (a3 == 1 && b3 == 1 && c3 == 3)) {
                    to_return = (int)Combination_worth.Three;
                } else {
                    to_return = (int)Combination_worth.Two;
                }

                break;

            case 4:
                // One pair
                to_return = (int)Combination_worth.One;

                break;

            case 5:
                // High card
                to_return = (int)Combination_worth.High;
                break;
        }

        return to_return;
    }

    public static void Swap<T>(List<T> list, int indexA, int indexB){
        T tmp = list[indexA];
        list[indexA] = list[indexB];
        list[indexB] = tmp;
    }

    static int Is_stronger(string a, string b) {
        // is 'a' stronger than 'b'
        int result = -1; // 0 - yes, 1 - no, -1 - unclear
        
        for(int i = 0; i < a.Length; i++) {
            
            if (cards_strength[char.ToString(a[i])] > cards_strength[char.ToString(b[i])]) {
                result = 0;
                break; 
            }
            
            else if (cards_strength[char.ToString(a[i])] < cards_strength[char.ToString(b[i])]) {
                result = 1;
                break; 
            }
        }

        return result;
    }

    static void Main(string[] args){
        if (args.Length == 0) {
            Console.WriteLine("Expecting an input file");
            return;
        }

        var file_name = args[0];
        var lines = File.ReadAllLines(file_name);
        List<Card> cards = new List<Card>{};

        for (var i = 0; i < lines.Length; i += 1) {
            string[] split_lines = lines[i].ToString().Split(" ");
            
            for (int x = 0; x < split_lines.Length; x+=2) {
                string card = split_lines[x];
                int values = int.Parse(split_lines[x+1]);
                int card_type = Identify_kind(card);

                Card card_struct = new Card{
                    str = card,
                    value = values,
                    type = card_type
                };

                cards.Add(card_struct);
            }
        }

        bool clean_run = true;

        while (clean_run) {
            clean_run = true;
            for (int i = 0; i < cards.Count-1; i++) {
                for (int x = i+1; x < cards.Count; x++) {
                    Card a = cards[i];
                    Card b = cards[x];

                    if (a.type < b.type) {
                        Card temp = a;
                        cards[i] = b;
                        cards[x] = temp;
                        clean_run = false;

                    } else if (a.type == b.type) {
                        int stronger_result = Is_stronger(a.str, b.str);


                        if (stronger_result == 1) {
                            Card temp = b;
                            cards[x] = a;
                            cards[i] = temp;
                            clean_run = false;
                            
                        }
                    }
                }
            }

            if (clean_run) {
                break;
            }
        }

        int part_sum = 0;
        for (int i = 0; i < cards.Count; i++) {
            Card a = cards[i];
            //Console.WriteLine(string.Format("str: {0} , type: {1}, value: {2}", a.str, a.type.ToString(), a.value));
            int value = cards.Count - i;
            
            part_sum += a.value * value;
        }

        Console.WriteLine(String.Format("Part 1: {0}", part_sum));
        

    }
}
