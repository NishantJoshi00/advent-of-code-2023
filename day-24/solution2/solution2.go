package main

import (
	"bufio"
	"fmt"
	"gonum.org/v1/gonum/mat"
	"math"
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

func input() [][6]int {
	var output [][6]int
	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {
		text := strings.TrimSpace(scanner.Text())
		output = append(output, parse(text))
	}

	return output
}

func solve_xy(lines [][6]int) (*mat.VecDense, error) {
	n := len(lines)

	A := mat.NewDense(n, 6, nil)
	c := mat.NewVecDense(n, nil)

	for i := 0; i < n; i++ {
		x1 := float64(lines[i][0])
		y1 := float64(lines[i][1])
		vx1 := float64(lines[i][3])
		vy1 := float64(lines[i][4])
		A.SetRow(i, []float64{vy1, -1, x1, -vx1, 1, -y1})
		c.SetVec(i, x1*vy1-y1*vx1)
	}

	var X mat.VecDense

	err := X.SolveVec(A, c)

	return &X, err
}

func solve_zy(lines [][6]int) (*mat.VecDense, error) {
	n := len(lines)

	A := mat.NewDense(n, 6, nil)
	c := mat.NewVecDense(n, nil)

	for i := 0; i < n; i++ {
		z1 := float64(lines[i][2])
		y1 := float64(lines[i][1])
		vz1 := float64(lines[i][5])
		vy1 := float64(lines[i][4])
		A.SetRow(i, []float64{vy1, -1, z1, -vz1, 1, -y1})
		c.SetVec(i, z1*vy1-y1*vz1)
	}

	var X mat.VecDense

	err := X.SolveVec(A, c)

	return &X, err
}

func resolve(xy_solve, zy_solve *mat.VecDense) [3]int {
	var output [3]int
	x := xy_solve.AtVec(0)
	y := xy_solve.AtVec(3)

	z := zy_solve.AtVec(0)

	output[0] = int(math.Round(x))
	output[1] = int(math.Round(y))
	output[2] = int(math.Round(z))

	return output
}

func sum(input []int) int {
	output := 0
	for _, el := range input {
		output += el
	}
	return output
}

func main() {
	input_data := input()

	value, _ := solve_xy(input_data)
	value2, _ := solve_zy(input_data)
	output := resolve(value, value2)

  fmt.Println(sum(output[:]))

}
