package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func bubblesort(arr []int) []int {

	for i := 0; i < len(arr); i++ {
		for k := i + 1; k < len(arr); k++ {
			if arr[i] > arr[k] {
				temp := arr[k]
				arr[k] = arr[i]
				arr[i] = temp
			}
		}
	}

	return arr
}

func main() {
	args := os.Args
	input_file := ""

	if len(args) == 1 {
		fmt.Println("Error: Need to know input file!")
		fmt.Println("Usage: go run puzzel.go <input_file>")
		os.Exit(2)
	}

	input_file = os.Args[1]

	file, err := os.Open(input_file)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fileScanner := bufio.NewScanner(file)

	fileScanner.Split(bufio.ScanLines)

	total_amount_of_calories := []int{}
	current_amount_of_calories := 0
	line := ""

	for fileScanner.Scan() {
		line = fileScanner.Text()
		if line != "" { // We don't like empty lines
			i_repr, err := strconv.Atoi(line)

			if err != nil {
				fmt.Println(err.Error())
				os.Exit(1)
			}
			current_amount_of_calories += i_repr
		} else {
			total_amount_of_calories = append(total_amount_of_calories, current_amount_of_calories)
			current_amount_of_calories = 0 // Reset
		}
	}
	// The last integer valu	fmt.Println(total_amount_of_calories)
	total_amount_of_calories = bubblesort(total_amount_of_calories) // index 0 - min value and the last element is the max one

	fmt.Printf("Max value is %d\n", total_amount_of_calories[len(total_amount_of_calories)-1])

	sum_of_top_three := 0
	for i := 1; i <= 3; i++ {
		sum_of_top_three += total_amount_of_calories[len(total_amount_of_calories)-i]
	}

	fmt.Printf("The sum of the top three are: %d\n", sum_of_top_three)
}
