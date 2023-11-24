extends Node2D

const bullet_diamond = preload("res://src/scenes/battle/bullet/BT_BL_DIAMOND_B.tscn")

var startup_timer := 0.5
var camera_debug = Camera2D.new()

var bullet_timer := 0.0
var bullet_limit := 0.12
var spawn_rect := Rect2(-68, 86, 136, 56)

func choose_random_position(r: Rect2) -> Vector2:
	randomize()
	return Vector2(
	rand_range(r.position.x, r.end.x),
	rand_range(r.position.y, r.end.y))

func create_bullet(pos: Vector2):
	var new_bullet = bullet_diamond.instance()
	new_bullet.position = pos
	add_child(new_bullet)

func _ready():
	if get_parent().name == "root":
		camera_debug.current = true
		add_child(camera_debug)

func _process(delta):
	startup_timer = max(startup_timer - delta, 0)
	
	if startup_timer <= 0:
		bullet_timer += delta
	if bullet_timer > bullet_limit:
		create_bullet(choose_random_position(spawn_rect))
		bullet_timer = 0
	
	if !has_node("DefaultBox"):
		for x in get_child_count():
			get_child(x).queue_free()
	if get_child_count() <= 0 and startup_timer <= 0:
		queue_free()

func attack_done():
	$DefaultBox.get_node("Anime").play("ending")
