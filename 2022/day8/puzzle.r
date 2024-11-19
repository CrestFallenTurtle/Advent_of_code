args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
    print("Error: Needs input file")
    print("Usage: Rscript puzzle.r <input_file>")
    quit()
}

# Assigns the variable the value of our file to read
assign("file_name", args[1])

# Check if the file exists
if (!file.exists(file_name)) {
    print("Error: Failed to find the provided file")
    quit()
}

inc <- function(x) {
    eval.parent(substitute(x <- x + 1))
}

dec <- function(x) {
    eval.parent(substitute(x <- x - 1))
}


my_con <- file(description = file_name, open = "r", blocking = TRUE)
guts <- list()


x_length <- 0 # Amount of columns
y_length <- 1 # Amount of rows

repeat {
    line <- readLines(my_con, n = 1) # Read one line.

    # If the line is empty, exit.
    if (identical(line, character(0))) {
        break
    }

    if (x_length == 0) { # Need to only assign it once
        x_length <- nchar(line)
    }

    line <- strsplit(line, split = "") # Split it after each character

    guts[y_length] <- line
    inc(y_length)
}
close(my_con)
rm(my_con)

dec(y_length)

# Convert the gut to a matrix
guts <- matrix(unlist(guts), nrow = y_length, byrow = TRUE)

# We know per default that the outmost outer rim is not neeed
x_cord <- 2
y_cord <- 2
#print(guts)

is_visible <- matrix(sample(c("No", "No"), x_length * y_length,
replace = TRUE), nrow = y_length)

# Convert to boolean matrix
is_visible[, ] <- ifelse(is_visible %in% c("No"), FALSE, TRUE)

# We must update the outer rim
for (x_cord in 1:x_length){ # Start with x
    is_visible[1, x_cord] <- "TRUE"
    is_visible[y_length, x_cord] <- "TRUE"
}

for (y_cord in 1:y_length){ # and now y
    is_visible[y_cord, 1] <- "TRUE"
    is_visible[y_cord, x_length] <- "TRUE"
}

# Check the row
for (y_cord in 2:(y_length - 1)) {
    for (x_cord in 2:(x_length - 1)){
        # We don't want to check a tree that we already has confirmed
        # As visible
        if (is_visible[y_cord, x_cord] != "TRUE") {
            tree_height <- strtoi(guts[y_cord, x_cord])
            left <- strtoi(max(guts[y_cord, 1:(x_cord - 1)]))
            right <- strtoi(max(guts[y_cord, (x_cord + 1):x_length]))

            if (left < tree_height || right < tree_height) {
                is_visible[y_cord, x_cord] <- "TRUE"
            }
        }
    }
}
#print(is_visible)

# Check the column we are in
for (x_cord in 2:(x_length - 1)) {
    for (y_cord in 2:(y_length - 1)){
        # We don't want to check a tree that we already has confirmed
        # As visible
        if (is_visible[y_cord, x_cord] != "TRUE") {
            tree_height <- strtoi(guts[y_cord, x_cord])
            up <- strtoi(max(guts[1:(y_cord - 1), x_cord]))
            down <- strtoi(max(guts[(y_cord + 1):y_length, x_cord]))

            if (up < tree_height || down < tree_height) {
                is_visible[y_cord, x_cord] <- "TRUE"
            }
        }
    }
}

visible_trees <- 0

for (y_cord in 1:y_length) {
    for (x_cord in 1:x_length){
        if (is_visible[y_cord, x_cord] == "TRUE"){
            inc(visible_trees)
        }
    }
}

cat(sprintf("[PART 1] Amount of visible trees: %d\n", visible_trees))

scenic_scores <- matrix(sample(c("1", "1"), x_length * y_length,
replace = TRUE), nrow = y_length)

# Convert to boolean matrix
scenic_scores[, ] <- ifelse(scenic_scores %in% c("1"), 1, 0)

# We must update the outer rim
for (x_cord in 1:x_length){ # Start with x
    scenic_scores[1, x_cord] <- 0
    scenic_scores[y_length, x_cord] <- 0
}

for (y_cord in 1:y_length){ # and now y
    scenic_scores[y_cord, 1] <- 0
    scenic_scores[y_cord, x_length] <- 0
}

#print(scenic_scores)


for (y_cord in 2:(y_length - 1)) {
    for (x_cord in 2:(x_length - 1)) {
        tree_height <- strtoi(guts[y_cord, x_cord])

        #print(tree_height)
        # Left
        x <- (x_cord  - 1) # We don't want to check our own element
        left_value <- 0
        while (x > 0) {
            inc(left_value)
            if (strtoi(guts[y_cord, x]) >= tree_height) {
                break
            }

            #print(guts[y_cord, x])
            dec(x)
        }

        # Right
        x <- (x_cord + 1)
        right_value <- 0
        while (x < (x_length + 1)) {
            inc(right_value)
            if (strtoi(guts[y_cord, x]) >= tree_height) {
                break
            }

            #print(guts[y_cord, x])
            inc(x)
        }

        # Up
        y <- (y_cord - 1)
        up_value <- 0
        while (y > 0) {
            inc(up_value)
            if (strtoi(guts[y, x_cord]) >= tree_height) {
                break
            }

            #print(guts[y, x_cord])
            dec(y)
        }

        # Down
        y <- (y_cord + 1)
        down_value <- 0
        while (y < (y_length + 1)) {
            inc(down_value)
            if (strtoi(guts[y, x_cord]) >= tree_height) {
                break
            }

            #print(guts[y, x_cord])
            inc(y)
        }

        # cat(sprintf("### %d:%d\n", y_cord, x_cord))
        # cat(sprintf("right: %d\n", right_value))
        # cat(sprintf("left: %d\n", left_value))
        # cat(sprintf("down: %d\n", down_value))
        # cat(sprintf("up: %d\n\n", up_value))
        # print("------------------")

        scenic_scores[y_cord, x_cord] <- left_value*right_value*up_value*down_value
    }
}

#print(scenic_scores)

largest_value <- 0
# Find the largest value
for (y_cord in 1:y_length) {
    for (x_cord in 1:x_length){
        if (strtoi(scenic_scores[y_cord, x_cord]) > largest_value){
            largest_value <- strtoi(scenic_scores[y_cord, x_cord])
        }
    }
}

cat(sprintf("[PART 2] Highest scenic score: %s\n", largest_value))
