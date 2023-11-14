extends Area2D

var speed = 0
var direction = 0
var damage: int = 1
var behavior: int = 0
var grazed = false

func _process(delta):
	var velocity = Vector2.RIGHT
	velocity = velocity.normalized().rotated(deg2rad(direction)) * speed
	position += velocity * delta
	grazed = false

func _on_Notifier_screen_exited():
	queue_free()
