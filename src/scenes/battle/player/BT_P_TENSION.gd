extends TextureRect

onready var tween = $Tween

var tension_points setget _set_tension_points

func _set_tension_points(value):
	var previous_tension = tension_points
	tension_points = value
	if previous_tension < tension_points:
		increasing_tp()
	elif previous_tension > tension_points:
		decreasing_tp()

func increasing_tp():
	tween.start()
	tween.interpolate_property($White, "value", null,
	tension_points, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property($Orange, "value", null,
	tension_points, 0.4, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.interpolate_property($Red, "value", null,
	tension_points, 0.41, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)

func decreasing_tp():
	tween.start()
	tween.interpolate_property($White, "value", null,
	tension_points, 0.4, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.interpolate_property($Orange, "value", null,
	tension_points, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property($Red, "value", null,
	tension_points, 0.4, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)

func _ready():
	$White.value = 0
	$Orange.value = 0
	$Red.value = 0
	tension_points = 0

func _process(_delta):
	if tension_points >= 250:
		$PercentTexture.hide()
		$NumberLabel.hide()
		$MaxTexture.show()
		$White.tint_progress = Color(1,1,0,1)
		$Orange.tint_progress = Color(1,1,0,1)
	else:
		$PercentTexture.show()
		$NumberLabel.show()
		$MaxTexture.hide()
		$White.tint_progress = Color(1,1,1,1)
		$Orange.tint_progress = Color(1,0.63,0.25,1)
	
	$NumberLabel.text = str(int(inverse_lerp(0, 250, tension_points) * 100))
