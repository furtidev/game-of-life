package main

import rl "vendor:raylib"
import "core:math/rand"

WINDOW_WIDTH  :: 800
WINDOW_HEIGHT :: 600
CELL_SIZE     :: 10
DENSITY       :: 80

main :: proc() {
	// raylib init stuff
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Cellular Automata")
	defer rl.CloseWindow()

	rl.SetTargetFPS(30)

	// cellular automata init stuff
	grid := make_grid(DENSITY)

	// game loop
	for !rl.WindowShouldClose() {
		// update
		iterate(&grid)
		
		// draw
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		for i in 0..<WINDOW_WIDTH/CELL_SIZE {
			for j in 0..<WINDOW_HEIGHT/CELL_SIZE {
				if grid[j][i] == 1 {
					rl.DrawRectangle(cast(i32)i*CELL_SIZE, cast(i32)j*CELL_SIZE, CELL_SIZE, CELL_SIZE, rl.GREEN)
				}
			}
		}
		rl.EndDrawing()
	}
}

// Generate a grid with random values
make_grid :: proc(density: int) -> [WINDOW_HEIGHT/CELL_SIZE][WINDOW_WIDTH/CELL_SIZE]int {
	grid := [WINDOW_HEIGHT/CELL_SIZE][WINDOW_WIDTH/CELL_SIZE]int{}
	for i in 0..<WINDOW_HEIGHT/CELL_SIZE {
		for j in 0..<WINDOW_WIDTH/CELL_SIZE {
			random := rand.int_max(100)
			if random > density {
				grid[i][j] = 0
			} else {
				grid[i][j] = 1
			}
		}
	}
	return grid
}

// conway's game of life
iterate :: proc(grid: ^[WINDOW_HEIGHT/CELL_SIZE][WINDOW_WIDTH/CELL_SIZE]int) {
	temp_grid := grid^
	for i in 0..<WINDOW_HEIGHT/CELL_SIZE {
		for j in 0..<WINDOW_WIDTH/CELL_SIZE {
			curr := temp_grid[i][j]
			neighbors := get_neighbors(temp_grid, i, j) - curr
			if neighbors == 3 && curr == 0 {
				grid[i][j] = 1
			} else if (neighbors < 2 || neighbors > 3) && curr == 1 {
				grid[i][j] = 0
			}
		}
	}
}

// get neighbor count of cell
get_neighbors :: proc(grid: [WINDOW_HEIGHT/CELL_SIZE][WINDOW_WIDTH/CELL_SIZE]int, i, j: int) -> int {
	n: int
	for y in -1..<2 {
		for x in -1..<2 {
			if !(i+y < 0 || j+x < 0 || i+y >= (WINDOW_HEIGHT/CELL_SIZE) || j+x >= (WINDOW_WIDTH/CELL_SIZE)) {
					n += grid[i+y][j+x]
			}
		}
	}
	return n
}