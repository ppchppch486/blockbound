class_name BlockPiece
extends Node2D
const CELL := 48
const COLORS := [Color("#4da6ff"), Color("#bd73ff"), Color("#ff667d")]
var block_type := 0
var direction := 0
func setup(new_type: int, new_direction: int) -> void:
	block_type = new_type
	direction = new_direction
	queue_redraw()
func _draw() -> void:
	var color: Color = COLORS[block_type]
	var rect := Rect2(Vector2(5, 5), Vector2(CELL - 10, CELL - 10))
	draw_rect(rect, color.darkened(0.35), true)
	draw_rect(rect, color, false, 3)
	var vectors: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
	var facing: Vector2 = vectors[direction]
	var center := Vector2(CELL, CELL) / 2
	draw_line(center - facing * 10, center + facing * 10, Color.WHITE, 3)
	draw_circle(center + facing * 11, 4, Color.WHITE)
	if block_type == 1: draw_circle(center, 5, Color("#f0c8ff"))
	elif block_type == 2:
		draw_line(center - Vector2(8, 8), center + Vector2(8, 8), Color("#ffd0d9"), 3)
		draw_line(center - Vector2(8, -8), center + Vector2(8, -8), Color("#ffd0d9"), 3)
