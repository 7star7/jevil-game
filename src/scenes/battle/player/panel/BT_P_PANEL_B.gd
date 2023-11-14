extends TextureButton

export(int) var id = 0
export(Resource) var dataset

func _ready():
	if dataset != null:
		name = dataset.n_name
		id = dataset.id
		texture_normal = dataset.texture_normal
		texture_focused = dataset.texture_focused
		texture_pressed = texture_focused

func _on_self_focus_entered():
	pressed = false
