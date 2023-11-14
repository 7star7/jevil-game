extends Node2D

const bullet_normal = preload("res://src/scenes/battle/bullet/BT_BL_NORMAL.tscn")

var ring_timer = 0.0
var ring_cooldown = 0.9

func create_bullet(bullet_type, pos, degree = 90, speed = 120, dmg = 1):
	var bullet = bullet_type.instance()
	bullet.global_position = pos
	bullet.direction = degree
	bullet.speed = speed
	bullet.damage = dmg
	bullet.set_as_toplevel(true)
	get_parent().add_child(bullet)

func create_ring(pos, degree = 90):
	degree -= 18
	for x in 9:
		create_bullet(bullet_normal, pos, degree, 280, 5)
		degree += 4.5

func _ready():
	if get_parent() == get_tree().root:
		position = Vector2(320, 62)

func _process(delta):
	ring_timer += delta
	if ring_timer > ring_cooldown:
		create_ring(global_position + Vector2(rand_range(-4, 4),rand_range(-2, 2)),
		rand_range(85.5, 94.5))
		ring_timer = 0
