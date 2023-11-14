extends ColorRect

var direction := false # false = From L to R, true = From R to L
var speed = 0.3

func _ready():
	if direction:
		grow_horizontal = Control.GROW_DIRECTION_END
		anchor_left = 1
		anchor_right = 1
		margin_left = -2
		margin_right = 0

func _physics_process(_delta):
	if direction:
		margin_left -= speed
		margin_right -= speed
	else:
		margin_left += speed
		margin_right += speed
	color.a = max(0, color.a - 0.008)
	if color.a < 0.5:
		speed = 0.5
	if color.a == 0:
		queue_free()
