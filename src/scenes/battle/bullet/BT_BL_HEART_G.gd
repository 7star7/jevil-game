extends Node2D

var speed = 180
var direction = 90

func _process(delta):
	$RotatingCircle.rotate(delta * 2)
	
	var velocity = Vector2(1, 0)
	velocity = velocity.normalized().rotated(deg2rad(direction)) * speed
	position += velocity * delta

func _on_Notifier_screen_exited():
	queue_free()
