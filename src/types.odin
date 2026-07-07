package main

Game_State :: enum {
	Start_Page,
	Playing,
	Score_Page,
}

Tile :: enum {
	None,
	Apple,
	Up,
	Down,
	Left,
	Right,
}

Position :: struct {
	x: int,
	y: int,
}

Snake :: struct {
	score: u16,
	head:  Position,
	tail:  Position,
}

Snake_State :: enum {
	Apple,
	Moved,
	Collision,
}

// Package-level game state
gameState := Game_State.Start_Page
board := [GRID][GRID]Tile{}
snake := Snake {
	score = 0,
	head = Position{x = GRID / 2, y = GRID / 2},
	tail = Position{x = GRID / 2 + 1, y = GRID / 2},
}
snake_state := Snake_State.Apple
