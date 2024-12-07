use builtin qw(trim);

my $file = @ARGV[0];
my $stop_adding_rules = 0;
my @rules = ();
my @updates = ();
my $part_1_value = 0;
my $part_2_value = 0;

open(FH, $file) or die "Failed to open file $file";

while (<FH>) {
    if ($_ eq "\n") {
        $stop_adding_rules = 1;
        next;
    }
    $_ = trim($_);

    if ($stop_adding_rules eq 0) {
        push(@rules, $_);
    } else {
        push(@updates, $_);
    }
}
close FH;

for my $update (@updates) {
    my @split_lines = split(",", $update);
    my $middle_value = $split_lines[int($#split_lines / 2)];

    my $all_clear = 1; # Assume valid until proven otherwise
    
    # Fix up targets
    my %targets = ();
    for my $i (0 .. $#split_lines) {
        my $master = $split_lines[$i];
        foreach my $sub (@split_lines[$i + 1 .. $#split_lines]) {
            my $target = "$master|$sub";
            $targets{$target} = 0;
        }
    }

    # Look for our key targets
    for (keys %targets) {
        foreach my $rule (@rules) {
            if ($_ eq $rule) {
                $targets{$_} = 1;
            }
        }
    }

    # Is it valid?
    for (keys %targets) {
        if ($targets{$_} == 0) {
            $all_clear = 0;
            last;
        }
    }

    # Part 1: If every value appeared correctly, then we add it
    if ($all_clear) {
        $part_1_value += $middle_value;
    }

    # Part 2: Fix invalid updates
    if (!$all_clear) {
        # Generate all possible relationships
        my %relationships = ();
        for my $i (0 .. $#split_lines) {
            my $master = $split_lines[$i];
            foreach my $sub (@split_lines) {
                next if $master eq $sub; # Skip identical values
                my $target = "$master|$sub";
                $relationships{$target} = 0;
            }
        }

        # Validate relationships
        for (keys %relationships) {
            foreach my $rule (@rules) {
                if ($_ eq $rule) {
                    $relationships{$_} = 1;
                }
            }
        }

        # Order pages based on valid relationships
        my @sorted_pages = sort {
            my $a_before_b = $relationships{"$a|$b"} || 0;
            my $b_before_a = $relationships{"$b|$a"} || 0;
            return $a_before_b ? -1 : $b_before_a ? 1 : 0;
        } @split_lines;

        # Find the middle value of the sorted pages
        $middle_value = $sorted_pages[int($#sorted_pages / 2)];
        $part_2_value += $middle_value;
    }
}

print "Part 1: $part_1_value\n";
print "Part 2: $part_2_value\n";
