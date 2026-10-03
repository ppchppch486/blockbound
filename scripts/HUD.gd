class_name PuzzleHUD
extends Control
const TYPES := ["基础方块", "复制方块", "摧毁方块"]
const COLORS := [Color("#4da6ff"), Color("#bd73ff"), Color("#ff667d")]
var selected_type := 0
var direction := 0
var message := "点击右侧方块类型选择，左键放置方块，右键移除方块"
var message_time := 0.0
func show_message(text: String) -> void: message = text; message_time = 2.0; queue_redraw()
func select_type_at(pos: Vector2) -> bool:
	for i in range(TYPES.size()):
		var rect := Rect2(914, 205 + i * 76, 174, 60)
		if rect.has_point(pos):
			selected_type = i
			show_message("已选择：%s" % TYPES[i])
			return true
	return false
func run_button_at(pos: Vector2) -> bool:
	return Rect2(914, 430, 174, 44).has_point(pos)
func _process(delta: float) -> void:
	if message_time > 0: message_time -= delta; queue_redraw()
func _draw() -> void:
	draw_string(ThemeDB.fallback_font, Vector2(72, 62), "BLOCKBOUND", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("#eaf2ff"))
	draw_string(ThemeDB.fallback_font, Vector2(72, 91), "方块解谜 · 节点化关卡原型", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("#7e9bc5"))
	draw_rect(Rect2(900, 142, 202, 372), Color("#151f36"), true)
	draw_rect(Rect2(900, 142, 202, 372), Color("#314364"), false, 2)
	draw_string(ThemeDB.fallback_font, Vector2(920, 178), "方块工具箱", HORIZONTAL_ALIGNMENT_LEFT, -1, 21, Color("#eaf2ff"))
	for i in range(TYPES.size()):
		var y := 205.0 + i * 76
		draw_rect(Rect2(914, y, 174, 60), Color("#263957") if i == selected_type else Color("#1b2942"), true)
		draw_circle(Vector2(938, y + 30), 16, COLORS[i])
		draw_string(ThemeDB.fallback_font, Vector2(966, y + 27), TYPES[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)
	draw_rect(Rect2(914, 430, 174, 44), Color("#347c62"), true)
	draw_string(ThemeDB.fallback_font, Vector2(974, 459), "运行一步", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color.WHITE)
	draw_string(ThemeDB.fallback_font, Vector2(920, 498), "方向", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#91a7c8"))
	draw_string(ThemeDB.fallback_font, Vector2(966, 503), ["→", "↓", "←", "↑"][direction], HORIZONTAL_ALIGNMENT_LEFT, -1, 26, COLORS[selected_type])
	draw_string(ThemeDB.fallback_font, Vector2(72, 585), "左键 放置 · 右键 移除 · 中键拖动 · 滚轮缩放 · Q / E 旋转 · R 清空 · 点击运行一步", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("#9bb2d5"))
	if message_time > 0: draw_string(ThemeDB.fallback_font, Vector2(72, 616), message, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("#69d6a0"))
