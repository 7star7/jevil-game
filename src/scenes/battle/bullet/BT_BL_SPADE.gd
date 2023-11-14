extends Area2D

var speed = 120
var direction = 90
var damage: int = 2
var grazed = false

func _process(delta):
	var velocity = Vector2(1, 0)
	velocity = velocity.normalized().rotated(deg2rad(direction)) * speed
	position += velocity * delta
	$Sprite.rotation_degrees = direction

func _on_Notifier_screen_exited():
	queue_free()
