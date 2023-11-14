extends StaticBody2D

const bx_blur = preload("res://src/scenes/battle/attack/BX_BLUR.tscn")

var camera_debug = Camera2D.new()

func spawn_blur():
	var new_blur = bx_blur.instance()
	new_blur.scale = $Box.scale
	new_blur.rotation_degrees = $Box.rotation_degrees
	add_child(new_blur)

func _ready():
	if get_parent().name == "root":
		camera_debug.current = true
		add_child(camera_debug)
