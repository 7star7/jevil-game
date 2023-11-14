extends Node2D

const ntd_depth = preload("res://src/scenes/menu/MN_BG_DEPTH.tscn")

var timer = 0.0
var timer_finished = 2.4

func _physics_process(delta):
	timer += 1 * delta
	if timer_finished < timer:
		for child in get_children():
			if child.name != "BottomDepth":
				child.z_index += 1
		add_child(ntd_depth.instance())
		timer = 0.0
