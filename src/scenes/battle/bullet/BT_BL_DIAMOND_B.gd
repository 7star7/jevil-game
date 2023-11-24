extends Area2D

var speed := 170.0
var direction := Vector2.UP

var damage := 2
var grazed := false

func _process(delta):
	var velocity = direction * speed
	position += velocity * delta

func _on_Notifier_screen_exited():
	queue_free()
