class_name BlockLayer
extends Node2D
const GROUND_Y := 19
const TYPES := ["基础方块", "复制方块", "摧毁方块"]
var block_scene: NodePath
var blocks: Dictionary = {}
func has_block(cell: Vector2i) -> bool: return blocks.has(cell)
func get_type(cell: Vector2i) -> int: return blocks.get(cell, -1)
func place(cell: Vector2i, selected_type: int, direction: int) -> String:
	if cell.y == GROUND_Y: return "地面不能被覆盖"
	var final_type := selected_type
	var result := "已放置：%s" % TYPES[selected_type]
	if selected_type == 1:
		result = "已放置复制方块（按运行执行复制）"
	elif selected_type == 2:
		result = "已放置摧毁方块（按运行执行摧毁）"
	remove(cell)
	spawn_block(cell, final_type, direction)
	return result

func spawn_block(cell: Vector2i, block_type: int, direction: int) -> void:
	var template: Node = null
	if str(block_scene) != "":
		template = get_node_or_null(block_scene)
	if template == null:
		template = get_node_or_null("../BlockPieceTemplate")
	if template == null:
		push_error("找不到 BlockPieceTemplate，无法生成方块")
		return
	var piece := template.duplicate() as BlockPiece
	piece.visible = true
	piece.name = "Block_%d_%d" % [cell.x, cell.y]
	piece.position = Vector2(cell.x * 48 + 72, cell.y * 48 + 142)
	piece.setup(block_type, direction)
	add_child(piece)
	blocks[cell] = block_type

func set_type(cell: Vector2i, new_type: int) -> void:
	if not blocks.has(cell): return
	blocks[cell] = new_type
	var piece := get_node_or_null("Block_%d_%d" % [cell.x, cell.y]) as BlockPiece
	if piece: piece.setup(new_type, piece.direction)

func is_valid_cell(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < 40 and cell.y >= 0 and cell.y < GROUND_Y

func push_block(cell: Vector2i, offset: Vector2i, state: Dictionary) -> bool:
	var destination: Vector2i = cell + offset
	if not is_valid_cell(destination): return false
	if state.has(destination) and not push_block(destination, offset, state): return false
	if blocks.has(destination): return false
	var piece := get_node_or_null("Block_%d_%d" % [cell.x, cell.y]) as BlockPiece
	var block_direction := piece.direction if piece else 0
	spawn_block(destination, state[cell], block_direction)
	remove(cell)
	return true

func run_step() -> String:
	var cells: Array = blocks.keys()
	var state: Dictionary = blocks.duplicate()
	var actions := 0
	# 第一阶段：先处理所有摧毁方块。
	for cell in cells:
		if not state.has(cell): continue
		var destroy_type: int = state[cell]
		if destroy_type != 2: continue
		var destroy_piece := get_node_or_null("Block_%d_%d" % [cell.x, cell.y]) as BlockPiece
		var destroy_facing := destroy_piece.direction if destroy_piece else 0
		var destroy_front: Vector2i = cell + [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP][destroy_facing]
		if state.has(destroy_front):
			remove(destroy_front)
			state.erase(destroy_front)
			actions += 1

	# 第二阶段：再处理复制方块，使用摧毁后的状态进行判定。
	for cell in cells:
		if not state.has(cell): continue
		var block_type: int = state[cell]
		if block_type != 1: continue
		var piece := get_node_or_null("Block_%d_%d" % [cell.x, cell.y]) as BlockPiece
		var facing := piece.direction if piece else 0
		var front: Vector2i = cell + [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP][facing]
		if state.has(front):
			# 保留复制方块，并在前方生成副本；有方块时先将其向前推开。
			var offset: Vector2i = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP][facing]
			var source_piece := get_node_or_null("Block_%d_%d" % [front.x, front.y]) as BlockPiece
			var source_direction := source_piece.direction if source_piece else facing
			if push_block(front, offset, state):
				spawn_block(front, state[front], source_direction)
				actions += 1
	return "运行完成：执行了 %d 个方块动作" % actions
func remove(cell: Vector2i) -> void:
	var base_name := "Block_%d_%d" % [cell.x, cell.y]
	# 立即删除，避免移动方块时旧节点在本帧继续存在并与新节点重名。
	for child in get_children():
		var child_name := str(child.name)
		if child is BlockPiece and (child_name == base_name or child_name.begins_with(base_name + "@")):
			child.free()
	blocks.erase(cell)
