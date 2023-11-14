extends Node2D

const bullet_spade = preload("res://src/scenes/battle/bullet/BT_BL_SPADE.tscn")

var speed = 230
var timelife = rand_range(0.68, 1.24)
var exploded = false

func create_bullet(bullet_type, pos, degree = 90, speed_b = 120, dmg = 1):
	var bullet = bullet_type.instance()
	bullet.global_position = pos
	bullet.direction = degree
	bullet.speed = speed_b
	bullet.damage = dmg
	bullet.set_as_toplevel(true)
	get_parent().add_child(bullet)

func create_ring():
	var degree = randi() % 30
	for x in 12:
		create_bullet(bullet_spade,
		self.global_position, degree, 200, 5)
		degree += 30

func _ready():
	$Explosion.hide()

func _physics_process(delta):
	if exploded:
		$Explosion.scale *= 1.032
		$Explosion.modulate.a -= 0.018
		if $Explosion.modulate.a <= 0:
			queue_free()
		return
	
	var velocity = Vector2(0, speed)
	position += velocity * delta
	
	timelife -= delta
	if timelife <= 0:
		create_ring()
		$AudioStream.play()
		$Explosion.show()
		$AnimeSprite.hide()
		exploded = true
