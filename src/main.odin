package main

import rl "../raylib"

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
