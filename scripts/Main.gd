extends Node2D
@onready var grid: LevelGrid = $World/LevelGrid
@onready var block_layer: BlockLayer = $World/PlacedBlocks
@onready var hud: PuzzleHUD = $UI/HUD
var direction := 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if hud.select_type_at(event.position): return
			if hud.run_button_at(event.position):
				hud.show_message(block_layer.run_step())
				return
		var cell := grid.world_to_cell(get_global_mouse_position())
		if not grid.is_inside(cell): return
		if event.button_index == MOUSE_BUTTON_LEFT: hud.show_message(block_layer.place(cell, hud.selected_type, direction))
		elif event.button_index == MOUSE_BUTTON_RIGHT: block_layer.remove(cell); hud.show_message("已移除方块")
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q: direction = (direction + 3) % 4
		elif event.keycode == KEY_E: direction = (direction + 1) % 4
		elif event.keycode == KEY_R:
			for cell in block_layer.blocks.keys(): block_layer.remove(cell)
			hud.show_message("已清空放置的方块")
		hud.direction = direction
		hud.queue_redraw()
