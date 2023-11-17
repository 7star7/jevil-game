extends Node2D

const bullet_heart_g = preload("res://src/scenes/battle/bullet/BT_BL_HEART_G.tscn")

var speed = 230
var timelife = rand_range(0.68, 1.24)
var exploded = false

#func create_bullet(bullet_type, pos, degree = 90, speed_b = 120, dmg = 1):
#	var bullet = bullet_type.instance()
#	bullet.global_position = pos
#	bullet.direction = degree
#	bullet.speed = speed_b
#	bullet.damage = dmg
#	bullet.set_as_toplevel(true)
#	get_parent().add_child(bullet)

func create_group():
	var group = bullet_heart_g.instance()
	group.global_position = self.global_position
	group.direction = rad2deg(get_angle_to(BattleGlobal.player_position))
	group.set_as_toplevel(true)
	get_parent().add_child(group)

#func create_three_way():
#	var degree := 0.0
#	if BattleGlobal.player_position != null:
#		degree = rad2deg(get_angle_to(BattleGlobal.player_position))
#
#	for x in 3:
#		create_bullet(bullet_diamond,
#		self.global_position, degree, d_speed, 5)
#		d_speed -= 35

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
		create_group()
		$AudioStream.play()
		$Explosion.show()
		$AnimeSprite.hide()
		exploded = true
