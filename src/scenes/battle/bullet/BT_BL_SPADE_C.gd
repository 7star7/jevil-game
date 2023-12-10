extends Area2D

var speed := 0.0
var direction := 0.0 # Radians this time
var damage: int = 2
var grazed = false

var start_timer := 1.0
var move_forward := false

func _process(delta):
	start_timer = max(start_timer - delta, 0)
	if move_forward:
		$Sprite.modulate = Color(1, 1, 1, 1)
		speed = min(speed + 4.0, 240.0)
	elif start_timer == 0:
		speed = max(speed - 0.2, -25.0)
		move_forward = true
	
	var velocity = Vector2(1, 0)
	velocity = velocity.normalized().rotated(direction) * speed
	position += velocity * delta
	$Sprite.rotation = direction

func _on_Notifier_screen_exited():
	queue_free()
