extends Node2D

# Thinking about it, all of the bomb variations can be a single scene.
# if you care enough. I don't, yet.
const bullet_bomb_club = preload("res://src/scenes/battle/bullet/BT_BL_BOMB_CLUB.tscn")

var startup_timer := 0.5
var bomb_timer = 0.0
var bomb_cooldown = 0.2
var bomb_bias := 0
var camera_debug = Camera2D.new()

func create_bomb():
	var bomb = bullet_bomb_club.instance()
	if bool(randi() % 2) and bomb_bias < 2:
		bomb.global_position = global_position + Vector2(rand_range(180, 290), -230)
		bomb_bias = int(max(bomb_bias + 1, 1))
	elif bomb_bias > -2:
		bomb.global_position = global_position + Vector2(rand_range(-180, -290), -230)
		bomb_bias = int(min(bomb_bias - 1, -1))
	else:
		bomb.global_position = global_position + Vector2(rand_range(180, 290), -230)
		bomb_bias = int(max(bomb_bias + 1, 1))
	bomb.set_as_toplevel(true)
	add_child(bomb)

func _ready():
	if get_parent().name == "root":
		camera_debug.current = true
		add_child(camera_debug)

func _process(delta):
	startup_timer = max(startup_timer - delta, 0)
	
	if startup_timer <= 0:
		bomb_timer += delta
	if bomb_timer > bomb_cooldown:
#		create_ring(global_position + Vector2(rand_range(4, -4),rand_range(-220, -228)),
#		rand_range(85.5, 94.5))
		create_bomb()
		bomb_timer = 0
		bomb_cooldown = rand_range(0.22, 0.48)
	
	if !has_node("DefaultBox"):
		for x in get_child_count():
			get_child(x).queue_free()
	if get_child_count() <= 0 and startup_timer <= 0:
		queue_free()

func attack_done():
	$DefaultBox.get_node("Anime").play("ending")
