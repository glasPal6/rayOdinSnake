package main

import rl "../raylib"
import "core:math/rand"

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
