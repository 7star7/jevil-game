extends Polygon2D

var double_frame := 0

func _physics_process(_delta):
	double_frame = double_frame + 1 % 2
	if bool(double_frame):
		color.a -= 0.055
	if color.a <= 0:
		queue_free()
