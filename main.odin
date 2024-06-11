package snek

import "core:fmt"
import "core:log"
import "core:os"
import "core:time"
import rl "vendor:raylib"

Pos :: struct {
	x, y: i32,
	w, h: i32,
}

Snake :: struct {
	alive:     bool,
	pos:       Pos,
	direction: Direction,
}

key_pressed_or_held :: proc(key: rl.KeyboardKey) -> bool {
	if (rl.IsKeyPressed(key) || rl.IsKeyPressedRepeat(key)) {
		return true
	}
	return false
}

Direction :: enum {
	north,
	south,
	east,
	west,
	none,
}

main :: proc() {
	rl.InitWindow(800, 800, "snek")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()
	snake := snake_init()
	should_close := false
	log_file, _ := os.open("log", os.O_CREATE | os.O_WRONLY, mode = 0o644)
	logger := log.create_file_logger(log_file, log.Level.Info)
	snake_append(&snake)
	context.logger = logger
	now := time.now()
	snake.direction = .none
	for !should_close {
		using snake
		rl.BeginDrawing()
		rl.ClearBackground(rl.GetColor(0x181818FF))
		key := rl.GetKeyPressed()
		if (key == .W) {
			direction = .north
		} else if (key == .S) {
			direction = .south
		} else if (key == .A) {
			direction = .west
		} else if (key == .D) {
			direction = .east
		}
		rl.DrawRectangle(pos.x, pos.y, pos.w, pos.h, rl.RED)
		if (time.duration_milliseconds(time.since(now)) >= 35) {
			now = time.now()
			if (pos.x + 25 == 0 || pos.x == rl.GetScreenWidth()) {
				log.log(log.Level.Info, "x", pos.x, "y", pos.y)
				game_over(&snake)
			}

			if (pos.y + 25 <= 0 || pos.y == rl.GetScreenHeight()) {
				log.log(log.Level.Info, "x", pos.x, "y", pos.y)
				game_over(&snake)
			}
			if (direction == .west) {
				pos.x -= 25
			}
			if (direction == .east) {
				pos.x += 25
			}
			if (direction == .north) {
				pos.y -= 25
			}
			if (direction == .south) {
				pos.y += 25
			}
		}

		if (key == .Q) {
			should_close = true
		}
		rl.EndDrawing()
	}
}

snake_init :: proc() -> (snake: Snake) {
	snake.alive = true
	snake.pos = Pos{rl.GetScreenWidth() / 2, rl.GetScreenHeight() / 2, 25, 25}
	//append(&snake.pos, Pos{rl.GetScreenWidth() / 2, rl.GetScreenHeight() / 2, 25, 25})
	return snake
}

snake_append :: proc(snake: ^Snake) {
	//last_piece := snake.pos[len(snake.pos) - 1]
	// append(&snake.pos, Pos{last_piece.x - 25, last_piece.y, 25, 25})
}

game_over :: proc(snake: ^Snake) {
	snake^ = snake_init()
	snake.direction = .none
}
