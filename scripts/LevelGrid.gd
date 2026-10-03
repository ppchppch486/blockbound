class_name LevelGrid
extends Node2D
const CELL := 48
const GRID_ORIGIN := Vector2(72, 142)
const GRID_SIZE := Vector2i(40, 20)
func _ready() -> void: queue_redraw()
func world_to_cell(pos: Vector2) -> Vector2i: return Vector2i(floor((pos.x - GRID_ORIGIN.x) / CELL), floor((pos.y - GRID_ORIGIN.y) / CELL))
func cell_to_world(cell: Vector2i) -> Vector2: return GRID_ORIGIN + Vector2(cell) * CELL
func is_inside(cell: Vector2i) -> bool: return cell.x >= 0 and cell.y >= 0 and cell.x < GRID_SIZE.x and cell.y < GRID_SIZE.y
func _draw() -> void:
	draw_rect(Rect2(-120, -80, 2280, 1320), Color("#0e1424"))
	draw_circle(Vector2(1680, 160), 260, Color("#172441"))
	draw_rect(Rect2(GRID_ORIGIN - Vector2(12, 12), Vector2(GRID_SIZE) * CELL + Vector2(24, 24)), Color("#151f36"), true)
	for y in range(GRID_SIZE.y):
		for x in range(GRID_SIZE.x):
			var rect := Rect2(cell_to_world(Vector2i(x, y)) + Vector2(1, 1), Vector2(CELL - 2, CELL - 2))
			draw_rect(rect, Color("#1c2942"), true)
			draw_rect(rect, Color("#293a5b"), false, 1.0)
	for x in range(GRID_SIZE.x):
		var ground := Rect2(cell_to_world(Vector2i(x, GRID_SIZE.y - 1)), Vector2(CELL, CELL))
		draw_rect(ground, Color("#315b54"), true)
		draw_line(ground.position + Vector2(0, 7), ground.position + Vector2(CELL, 7), Color("#67c58d"), 3)
