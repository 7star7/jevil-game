extends Node2D

const bullet_bomb_spade = preload("res://src/scenes/battle/bullet/BT_BL_BOMB_SPADE.tscn")

var startup_timer := 0.5
var ring_timer = 0.0
var ring_cooldown = 0.2
var spade_bias := 0
var camera_debug = Camera2D.new()

func create_bullet(bullet_type, pos, degree = 90, speed = 120, dmg = 1):
	var bullet = bullet_type.instance()
	bullet.global_position = pos
	bullet.direction = degree
	bullet.speed = speed
	bullet.damage = dmg
	bullet.set_as_toplevel(true)
	add_child(bullet)

func create_spade():
	var bomb = bullet_bomb_spade.instance()
	if bool(randi() % 2) and spade_bias < 2:
		bomb.global_position = global_position + Vector2(rand_range(180, 290), -230)
		spade_bias = int(max(spade_bias + 1, 1))
	elif spade_bias > -2:
		bomb.global_position = global_position + Vector2(rand_range(-180, -290), -230)
		spade_bias = int(min(spade_bias - 1, -1))
	else:
		bomb.global_position = global_position + Vector2(rand_range(180, 290), -230)
		spade_bias = int(max(spade_bias + 1, 1))
	bomb.set_as_toplevel(true)
	add_child(bomb)

func _ready():
	if get_parent().name == "root":
		camera_debug.current = true
		add_child(camera_debug)

func _process(delta):
	startup_timer = max(startup_timer - delta, 0)
	
	if startup_timer <= 0:
		ring_timer += delta
	if ring_timer > ring_cooldown:
#		create_ring(global_position + Vector2(rand_range(4, -4),rand_range(-220, -228)),
#		rand_range(85.5, 94.5))
		create_spade()
		ring_timer = 0
		ring_cooldown = rand_range(0.22, 0.48)
	
	if !has_node("DefaultBox"):
		for x in get_child_count():
			get_child(x).queue_free()
	if get_child_count() <= 0 and startup_timer <= 0:
		queue_free()

func attack_done():
	$DefaultBox.get_node("Anime").play("ending")
