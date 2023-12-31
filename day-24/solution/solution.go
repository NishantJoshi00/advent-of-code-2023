package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func parse(data string) [6]int {
	output := [6]int{}
	for idx, el := range strings.Split(strings.ReplaceAll(data, "@", ","), ",") {
		output[idx], _ = strconv.Atoi(strings.TrimSpace(el))
	}
	return output
}

// at least x and at most y
func intersection(p1, p2 [6]int, l, h int) (bool, float64, float64) {
	var Px, Py float64
	switch {
	case p1[3] == 0 && p2[3] == 0:
		if p1[0] != p2[0] {
			return false, -1, -1
		} else {
			return p1[0] >= l && p1[0] <= h, float64(p1[0]), -1
		}
	case p1[3] == 0:
		m2 := float64(p2[4]) / float64(p2[3])
		c2 := float64(p2[1]) - m2*float64(p2[0])
		Px = float64(p1[0])
		Py = m2*Px + c2

	case p2[3] == 0:
		m1 := float64(p1[4]) / float64(p1[3])
		c1 := float64(p1[1]) - m1*float64(p1[0])
		Px = float64(p2[0])
		Py = m1*Px + c1
	default:
		m1 := float64(p1[4]) / float64(p1[3])
		c1 := float64(p1[1]) - m1*float64(p1[0])
		m2 := float64(p2[4]) / float64(p2[3])
		c2 := float64(p2[1]) - m2*float64(p2[0])
		Px = (c2 - c1) / (m1 - m2)
		Py = m1*Px + c1
	}

	return Px >= float64(l) && Px <= float64(h) && Py >= float64(l) && Py <= float64(h), Px, Py
}

func input() [][6]int {
	var output [][6]int
	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {
		text := strings.TrimSpace(scanner.Text())
		output = append(output, parse(text))
	}

	return output
}

func in_future(Px, Py float64, a, b [6]int) bool {
	c1 := (Px-float64(a[0]))*float64(a[3]) >= 0 && (Py-float64(a[1]))*float64(a[4]) >= 0
	c2 := (Px-float64(b[0]))*float64(b[3]) >= 0 && (Py-float64(b[1]))*float64(b[4]) >= 0

	return c1 && c2
}

func main() {
	input_data := input()
	output := 0

	low, _ := strconv.Atoi(os.Args[1])
	high, _ := strconv.Atoi(os.Args[2])

	// low := 7
	// high := 27

	for i := 0; i < len(input_data); i++ {
		for j := i + 1; j < len(input_data); j++ {
			// _, c := visited[j]
			// _, d := visited[i]
			// if c || d {
			// 	continue
			// }
			canIntersect, x, y := intersection(input_data[i], input_data[j], low, high)
			if canIntersect {
				if in_future(x, y, input_data[i], input_data[j]) {
					output += 1
				}
			}
		}
	}

	fmt.Println(output)

}
