package main

import rl "../raylib"
// import rl "vendor:raylib"

DEBUG :: true

WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 800

GRID :: 20
TILE_WIDTH :: WINDOW_WIDTH / GRID
TILE_HEIGHT :: WINDOW_HEIGHT / GRID
BUFFER :: 1

when TILE_WIDTH <= BUFFER || TILE_HEIGHT <= BUFFER {
	#panic("GRID too large: tile dimensions must be bigger than BUFFER")
}

SNAKE_UP :: [?]rl.KeyboardKey{rl.KeyboardKey.W, rl.KeyboardKey.UP}
SNAKE_DOWN :: [?]rl.KeyboardKey{rl.KeyboardKey.S, rl.KeyboardKey.DOWN}
SNAKE_LEFT :: [?]rl.KeyboardKey{rl.KeyboardKey.A, rl.KeyboardKey.LEFT}
SNAKE_RIGHT :: [?]rl.KeyboardKey{rl.KeyboardKey.D, rl.KeyboardKey.RIGHT}

SNAKE_MOVEMENT_TIME :: 0.1
