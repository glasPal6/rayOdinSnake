package main

import rl "../raylib"
import "core:fmt"
// import rl "vendor:raylib"

draw_start_page :: proc() {
	title: cstring = "ODIN SNAKE"
	title_size :: 60
	title_width := rl.MeasureText(title, title_size)
	rl.DrawText(title, (WINDOW_WIDTH - title_width) / 2, 200, title_size, rl.GREEN)

	subtitle: cstring = "Press ENTER to play"
	sub_size :: 30
	sub_width := rl.MeasureText(subtitle, sub_size)
	rl.DrawText(subtitle, (WINDOW_WIDTH - sub_width) / 2, 340, sub_size, rl.RAYWHITE)

	controls: cstring = "WASD or Arrow Keys to move      ESC to quit"
	ctrl_size :: 20
	ctrl_width := rl.MeasureText(controls, ctrl_size)
	rl.DrawText(controls, (WINDOW_WIDTH - ctrl_width) / 2, 420, ctrl_size, rl.GRAY)
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
