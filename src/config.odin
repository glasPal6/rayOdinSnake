package main

import rl "../raylib"

DEBUG :: true

WINDOW_WIDTH  :: 800
WINDOW_HEIGHT :: 800

GRID        :: 20
TILE_WIDTH  :: WINDOW_WIDTH / GRID
TILE_HEIGHT :: WINDOW_HEIGHT / GRID
BUFFER      :: 1

when TILE_WIDTH <= BUFFER || TILE_HEIGHT <= BUFFER {
	#panic("GRID too large: tile dimensions must be bigger than BUFFER")
}

SNAKE_UP    :: rl.KeyboardKey.W
SNAKE_DOWN  :: rl.KeyboardKey.S
SNAKE_LEFT  :: rl.KeyboardKey.A
SNAKE_RIGHT :: rl.KeyboardKey.D
