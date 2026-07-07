package main

import "core:fmt"
import "core:math/rand"
// import rl "project:raylib"
import rl "../raylib"

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

SNAKE_UP :: rl.KeyboardKey.W
SNAKE_DOWN :: rl.KeyboardKey.S
SNAKE_LEFT :: rl.KeyboardKey.A
SNAKE_RIGHT :: rl.KeyboardKey.D

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

// Initialise the game state
gameState := Game_State.Start_Page

// Initialise the board
board := [GRID][GRID]Tile{}

// Initialise the Snake
snake := Snake {
	score = 0,
	head = Position{x = GRID / 2, y = GRID / 2},
	tail = Position{x = GRID / 2 + 1, y = GRID / 2},
}
snake_state := Snake_State.Apple

draw_start_page :: proc() {
	title: cstring = "ODIN SNAKE"
	title_size :: 60
	title_width := rl.MeasureText(title, title_size)
	rl.DrawText(title, (WINDOW_WIDTH - title_width) / 2, 200, title_size, rl.GREEN)

	subtitle: cstring = "Press ENTER to play"
	sub_size :: 30
	sub_width := rl.MeasureText(subtitle, sub_size)
	rl.DrawText(subtitle, (WINDOW_WIDTH - sub_width) / 2, 340, sub_size, rl.RAYWHITE)

	controls: cstring = "WASD to move      ESC to quit"
	ctrl_size :: 20
	ctrl_width := rl.MeasureText(controls, ctrl_size)
	rl.DrawText(controls, (WINDOW_WIDTH - ctrl_width) / 2, 420, ctrl_size, rl.GRAY)
}

reset_game :: proc() {
	snake = Snake {
		score = 0,
		head = Position{x = GRID / 2, y = GRID / 2},
		tail = Position{x = GRID / 2 + 1, y = GRID / 2},
	}
	board = [GRID][GRID]Tile{}
	board[snake.head.x][snake.head.y] = .Left
	board[snake.tail.x][snake.tail.y] = .Left
	snake_state = .Apple
}

draw_tile :: proc(x, y: int, colour: rl.Color) {
	rl.DrawRectangle(
		i32(x * TILE_WIDTH + BUFFER / 2),
		i32(y * TILE_HEIGHT + BUFFER / 2),
		TILE_WIDTH - BUFFER,
		TILE_HEIGHT - BUFFER,
		colour,
	)
}

draw_game :: proc() {
	// Draw the grid
	for x in 0 ..< GRID {
		for y in 0 ..< GRID {
			#partial switch board[x][y] {
			case .None:
				draw_tile(x, y, rl.GREEN)
			case .Apple:
				draw_tile(x, y, rl.RED)
			case:
				if (snake.head.x == x && snake.head.y == y) {
					draw_tile(x, y, rl.BLACK)
				} else if (snake.tail.x == x && snake.tail.y == y) {
					draw_tile(x, y, rl.YELLOW)
				} else {
					draw_tile(x, y, rl.BROWN)
				}
			}
		}
	}

	when DEBUG {
		rl.DrawFPS(10, 10)
	}
}

draw_score_page :: proc() {
	over: cstring = "GAME OVER"
	over_size :: 60
	over_width := rl.MeasureText(over, over_size)
	rl.DrawText(over, (WINDOW_WIDTH - over_width) / 2, 220, over_size, rl.RED)

	score_text := fmt.ctprintf("Score: %d", snake.score)
	score_size :: 40
	score_width := rl.MeasureText(score_text, score_size)
	rl.DrawText(score_text, (WINDOW_WIDTH - score_width) / 2, 340, score_size, rl.RAYWHITE)

	hint: cstring = "Press ENTER to return"
	hint_size :: 24
	hint_width := rl.MeasureText(hint, hint_size)
	rl.DrawText(hint, (WINDOW_WIDTH - hint_width) / 2, 440, hint_size, rl.GRAY)
}

input_to_snake :: proc() {
	current := board[snake.head.x][snake.head.y]
	#partial switch rl.GetKeyPressed() {
	case SNAKE_UP:
		if current != .Down {board[snake.head.x][snake.head.y] = .Up}
	case SNAKE_DOWN:
		if current != .Up {board[snake.head.x][snake.head.y] = .Down}
	case SNAKE_LEFT:
		if current != .Right {board[snake.head.x][snake.head.y] = .Left}
	case SNAKE_RIGHT:
		if current != .Left {board[snake.head.x][snake.head.y] = .Right}
	}
}


has_collided :: proc() -> Snake_State {
	// Out of bounds
	if snake.head.x < 0 || snake.head.x >= GRID || snake.head.y < 0 || snake.head.y >= GRID {
		return .Collision
	}

	// Allow moving into the tail's current cell
	if snake.head.x == snake.tail.x && snake.head.y == snake.tail.y {
		return .Moved
	}

	// Chech for an Apple
	if board[snake.head.x][snake.head.y] == .Apple {
		return .Apple
	}

	// Check if the head has moved to a position with a direction
	if board[snake.head.x][snake.head.y] != .None {
		return .Collision
	}

	return .Moved
}

update_snake :: proc() {
	// Move head
	#partial switch board[snake.head.x][snake.head.y] {
	case .Up:
		snake.head.y = (snake.head.y - 1)
		snake_state = has_collided()
		if snake_state == .Collision {return}
		board[snake.head.x][snake.head.y] = .Up
	case .Down:
		snake.head.y = (snake.head.y + 1)
		snake_state = has_collided()
		if snake_state == .Collision {return}
		board[snake.head.x][snake.head.y] = .Down
	case .Left:
		snake.head.x = (snake.head.x - 1)
		snake_state = has_collided()
		if snake_state == .Collision {return}
		board[snake.head.x][snake.head.y] = .Left
	case .Right:
		snake.head.x = (snake.head.x + 1)
		snake_state = has_collided()
		if snake_state == .Collision {return}
		board[snake.head.x][snake.head.y] = .Right
	}

	// Move tail
	if snake_state == .Moved {
		old_tail := snake.tail
		#partial switch board[snake.tail.x][snake.tail.y] {
		case .Up:
			snake.tail.y = (snake.tail.y - 1)
		case .Down:
			snake.tail.y = (snake.tail.y + 1)
		case .Left:
			snake.tail.x = (snake.tail.x - 1)
		case .Right:
			snake.tail.x = (snake.tail.x + 1)
		}
		board[old_tail.x][old_tail.y] = .None
	}
}

place_apple :: proc() -> bool {
	// Build array of available positions
	available_pos := make([dynamic]Position)
	defer delete(available_pos)

	for x in 0 ..< GRID {
		for y in 0 ..< GRID {
			if board[x][y] == .None {
				append(&available_pos, Position{x = x, y = y})
			}
		}
	}

	if len(available_pos) == 0 {
		return false
	}

	index := rand.int_max(len(available_pos))
	pos := available_pos[index]
	board[pos.x][pos.y] = .Apple

	return true
}

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Raylib Odin Snake")
	rl.rlViewport(0, 0, rl.rlGetFramebufferWidth() * 2, rl.rlGetFramebufferHeight() * 2)
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	tick_timer: f32 = 0.0

	board[GRID / 2][GRID / 2] = .Left
	board[GRID / 2 + 1][GRID / 2] = .Left

	for !rl.WindowShouldClose() {
		// Update phase
		switch gameState {
		case .Start_Page:
			if rl.GetKeyPressed() == rl.KeyboardKey.ENTER {
				reset_game()
				gameState = .Playing
			}
		case .Playing:
			input_to_snake()

			tick_timer += rl.GetFrameTime()
			if tick_timer >= 0.1 {
				tick_timer -= 0.1

				if snake_state == .Apple {
					can_place_apple := place_apple()
					if !can_place_apple {
						gameState = .Score_Page
					}
					snake_state = .Moved
				}

				update_snake()
				#partial switch snake_state {
				case .Apple:
					snake.score += 1
				case .Collision:
					gameState = .Score_Page
				}
			}
		case .Score_Page:
			if rl.GetKeyPressed() == rl.KeyboardKey.ENTER {
				gameState = .Start_Page
			}
		}

		// Draw phase
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.BLACK)

		switch gameState {
		case .Start_Page:
			draw_start_page()
		case .Playing:
			draw_game()
		case .Score_Page:
			draw_score_page()
		}
	}
}
