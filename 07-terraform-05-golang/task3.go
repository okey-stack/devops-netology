package main

import "fmt"
import "testing"

func task3_1() {
    fmt.Print("Enter distance in meters: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input / 0.3048

    fmt.Printf("Distance in ft: %6.2f\n", output)
}

func task3_2() {
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,-1,0}

    var min int
    min = x[0]
    for i := 1; i < len(x); i++ {
        if x[i] < min {
            min = x[i]
        }
    }
    fmt.Printf("Min: %d\n", min)
}

func task3_3() {
    fmt.Print("Enter min: ")
    var min int
    fmt.Scanf("%d", &min)

    fmt.Print("Enter max: ")
    var max int
    fmt.Scanf("%d", &max)

    for i := min; i <= max; i++ {
        if i % 3 == 0 {
            fmt.Printf("%6d ( %d : 3 = %d )\n", i, i, i / 3)
        }
    }
}

func main() {
    //task3_1()
    //task3_2()
    task3_3()
}