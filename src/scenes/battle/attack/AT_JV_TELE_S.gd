extends Node2D

const jevil_spade = preload("../bullet/BT_BL_JEVIL_TP_S.tscn")

var startup_timer := 0.5
var camera_debug = Camera2D.new()

var jevil_timer := 0.5
var jevil_cooldown := 1.0
var spawn_rect_left := Rect2(-148 - 108, -96, 108, 96 * 2)
var spawn_rect_right := Rect2(148, -96, 108, 96 * 2)
var is_left_side := true

func choose_random_position(r: Rect2) -> Vector2:
	randomize()
	return Vector2(
	rand_range(r.position.x, r.end.x),
	rand_range(r.position.y, r.end.y))

func create_bullet(pos: Vector2, left = false):
	var new_bullet = jevil_spade.instance()
	new_bullet.position = pos
	new_bullet.flip_h = left
	add_child(new_bullet)

func _ready():
	randomize()
	is_left_side = bool(randi() % 2)
	if get_parent().name == "root":
		camera_debug.current = true
		add_child(camera_debug)

func _process(delta):
	startup_timer = max(startup_timer - delta, 0)
	
	if startup_timer <= 0:
		jevil_timer += delta
	if jevil_timer > jevil_cooldown:
		if is_left_side:
			create_bullet(choose_random_position(spawn_rect_left), true)
		else:
			create_bullet(choose_random_position(spawn_rect_right))
		jevil_timer = 0
		is_left_side = !is_left_side
	
	if !has_node("DefaultBox"):
		for x in get_child_count():
			get_child(x).queue_free()
	if get_child_count() <= 0 and startup_timer <= 0:
		queue_free()

func attack_done():
	$DefaultBox.get_node("Anime").play("ending")
