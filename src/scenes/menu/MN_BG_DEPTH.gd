extends Node2D

func _physics_process(delta):
	modulate.a -= 0.075 * delta
	scale += Vector2(0.12, 0.12) * delta
	if modulate.a <= 0:
		queue_free()
