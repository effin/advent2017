package main

import (
	"fmt"
	"strconv"
	"strings"
)

func max(s []int) int {
	max := 0
	for i := 0; i < len(s); i++ {
		if s[i] > max {
			max = s[i]
		}
	}
	return max
}

func find(s []int, x int) int {
	for i := 0; i < len(s); i++ {
		if s[i] == x {
			return i
		}
	}
	return -1
}

func distribute(input []int) []int {
	m := max(input)
	s := find(input, m)
	input[s] = 0
	for i := 1; i <= m; i++ {
		input[(s+i)%len(input)]++
	}
	return input
}

func tostring(input []int) string {
	s := make([]string, len(input))
	for i := 0; i < len(input); i++ {
		s[i] = strconv.Itoa(input[i])
	}
	return strings.Join(s, "")
}

func part1(input []int) {
	done := map[string]bool{}
	count := 0
	for !done[tostring(input)] {
		done[tostring(input)] = true
		count++
		input = distribute(input)
	}
	fmt.Printf("part 1: %d \n", count)
}

func part2(input []int) {
	done := map[string]int{}
	count := 0
	for done[tostring(input)] == 0 {
		done[tostring(input)] = count
		count++
		input = distribute(input)
	}
	fmt.Printf("part 2: %d \n", count-done[tostring(input)])
}


func main() {
    input := []int{10, 3, 15, 10, 5, 15, 5, 15, 9, 2, 5, 8, 5, 2, 3, 6}
    part1(input)
    part2(input)
}

