package main

import rl "project:raylib"

main :: proc() {
	rl.InitWindow(800, 450, "raylib [core] example - basic window")
	rl.rlViewport(0, 0, rl.rlGetFramebufferWidth() * 2, rl.rlGetFramebufferHeight() * 2)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.RAYWHITE)
			rl.DrawText("Congrats! You created your first window!", 190, 200, 20, rl.LIGHTGRAY)
			rl.DrawFPS(10, 10)
		}
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
