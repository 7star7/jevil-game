extends KinematicBody2D

const sfx_hurt = preload("res://assets/sound/effects/SFX_UT_HURT.wav")
const sfx_graze = preload("res://assets/sound/effects/SFX_DR_GRAZE.wav")

onready var screen_size = get_viewport_rect().size
var moving = false
var grazing_bullets: int = 0
var grazing_strength := 0.0

signal hit
signal grazed

func grazing(area):
	$Graze.visible = true
	
	if area.grazed:
		grazing_strength = 0.99
	else:
		grazing_strength = 3.99
		AudioPlayer.play_sfx(sfx_graze, 0)
	
	emit_signal("grazed")
	area.grazed = true

func _ready():
	$Graze.visible = false

func _process(_delta):
	## Movement
	# In the original Undertale, the speed doesn't normailize.
	var current_speed = Vector2.ZERO
	if self.visible:
		if Input.is_action_pressed("ui_right"):
			current_speed.x += 1
		if Input.is_action_pressed("ui_left"):
			current_speed.x -= 1
		if Input.is_action_pressed("ui_down"):
			current_speed.y += 1
		if Input.is_action_pressed("ui_up"):
			current_speed.y -= 1
	if current_speed.length() > 0:
		if Input.is_action_pressed("action_focus"):
			current_speed = current_speed * 70
		else:
			current_speed = current_speed * 160
#	position += current_speed * delta
	current_speed = move_and_slide(current_speed)
	moving = (current_speed.length() > 0)
	
	## The heart's size is 16 pixels (border not included).
	## It's hardcoded because whenever I try to change the
	## sprite, I will always have to change this one too.
	## So there is not point in doing so.
	position.x = clamp(position.x, 8 * scale.x, screen_size.x - 8 * scale.x)
	position.y = clamp(position.y, 8 * scale.y, screen_size.y - 8 * scale.y)
	
	if !$InvicibleTimer.is_stopped():
		$Anime.play("Hit")

func _physics_process(delta):
	## Graze
	$Graze.frame = floor(grazing_strength)
	if grazing_bullets <= 0:
		grazing_strength = max(grazing_strength - (delta * 16), 0.0)
	else:
		grazing_strength = max(grazing_strength - (delta * 16), 0.99)
	if grazing_strength <= 0.0:
		$Graze.visible = false
	if !self.visible:
		grazing_strength = 0.0
		grazing_bullets = 0

func _on_Hitbox_area_entered(area):
	if self.visible:
		$InvicibleTimer.start()
		emit_signal("hit", area)
		AudioPlayer.play_sfx(sfx_hurt, 0)
		$Hitbox.set_deferred("monitoring", false)
		$Grazebox.set_deferred("monitoring", false)

func _on_Grazebox_area_entered(area):
	if self.visible:
		grazing_bullets += 1
		grazing(area)

func _on_Grazebox_area_exited(_area):
	if self.visible:
		grazing_bullets -= 1

func _on_InvicibleTimer_timeout():
	$Anime.stop()
	$Sprite.frame = 0
	$Hitbox.set_deferred("monitoring", true)
	$Grazebox.set_deferred("monitoring", true)
