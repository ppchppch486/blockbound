extends Camera2D

const MIN_ZOOM := 0.8
const MAX_ZOOM := 2.5
const ZOOM_STEP := 1.1
var dragging := false

func _ready() -> void:
	enabled = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			set_zoom_level(zoom.x * ZOOM_STEP)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			set_zoom_level(zoom.x / ZOOM_STEP)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom
		get_viewport().set_input_as_handled()

func set_zoom_level(level: float) -> void:
	var new_zoom: float = clampf(level, MIN_ZOOM, MAX_ZOOM)
	zoom = Vector2(new_zoom, new_zoom)
