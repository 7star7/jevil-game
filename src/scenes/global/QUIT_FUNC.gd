extends Node

onready var text = $TextImage
var timer = 0.0

func _ready():
	text.modulate.a = 0

func _process(delta):
	if Input.is_action_pressed("action_quit"):
		text.modulate.a = min(text.modulate.a + 1.5 * delta, 1)
		if text.modulate.a >= 1:
			timer += delta
	else:
		text.modulate.a = max(text.modulate.a - 1.5 * delta, 0)
		if timer > 0:
			timer = 0
	
	if timer >= 0.5:
		get_tree().quit()
