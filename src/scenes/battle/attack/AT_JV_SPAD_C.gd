extends Node2D

const bullet_spade = preload("res://src/scenes/battle/bullet/BT_BL_SPADE_C.tscn")

var startup_timer := 0.5
var ring_timer = 1.5
var ring_cooldown = 3.0
var camera_debug = Camera2D.new()

func create_bullet(bullet_type, pos, rad = 90, dmg = 1):
	var bullet = bullet_type.instance()
	bullet.global_position = pos
	bullet.direction = rad
	bullet.damage = dmg
	bullet.set_as_toplevel(true)
	add_child(bullet)
	return bullet

func create_ring(ring_num: int):
	var ring_duration := 2.4
	var ring_lenght := Vector2(136, 0)
	var rad: float = rand_range(0, TAU)
	for bull in ring_num:
		var bull_pos := ring_lenght.rotated(rad) + self.global_position
		var bull_ins = create_bullet(bullet_spade,
		bull_pos, rad - PI)
		bull_ins.start_timer = (ring_duration / ring_num) * (bull + 1)
		bull_ins.start_timer += 0.4 # Extra time to make it easy to read for now.
		rad += TAU / ring_num

func _ready():
	randomize()
	if get_parent().name == "root":
		camera_debug.current = true
		add_child(camera_debug)

func _process(delta):
	startup_timer = max(startup_timer - delta, 0)
	
	if startup_timer <= 0:
		ring_timer += delta
	if ring_timer > ring_cooldown:
		create_ring(14)
		ring_timer = 0
	
	if !has_node("DefaultBox"):
		for x in get_child_count():
			get_child(x).queue_free()
	if get_child_count() <= 0 and startup_timer <= 0:
		queue_free()

func attack_done():
	$DefaultBox.get_node("Anime").play("ending")
