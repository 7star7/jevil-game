extends Sprite

const DIAMOND_BULLET = preload("BT_BL_DIAMOND.tscn")

var counting_down := false
var leaving := false
var wait_time := 0.1
var start_timer := wait_time
var end_timer := wait_time

func create_spade(degree, b_speed, dmg = 1):
	var spade = DIAMOND_BULLET.instance()
	spade.scale = Vector2(0.4, 0.4)
	spade.global_position = self.global_position
	spade.direction = degree
	spade.speed = b_speed
	spade.damage = dmg
	spade.set_as_toplevel(true)
	get_parent().add_child(spade)

func spawn_bullets():
	var radian := 0.0
	if BattleGlobal.player_position != null:
		radian = get_angle_to(BattleGlobal.player_position)
	create_spade(rad2deg(radian), 280, 5)
	
	$Sound.play()
	leaving = true

func _process(delta):
	if counting_down:
		start_timer -= delta
		if start_timer < 0:
			counting_down = false
			spawn_bullets()
	
	if leaving:
		end_timer -= delta
		if end_timer < 0:
			leaving = false
			$Anime.play("disappear")

func _on_Anime_animation_finished(anim_name):
	if anim_name == "appear":
		counting_down = true
