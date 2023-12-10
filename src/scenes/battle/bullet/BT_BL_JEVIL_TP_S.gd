extends Sprite

const SPADE_BULLET = preload("BT_BL_SPADE.tscn")

var counting_down := false
var leaving := false
var wait_time := 0.4
var start_timer := wait_time
var end_timer := wait_time
const DIFF_DISTANCE = 12.5

func create_spade(degree, b_speed, dmg = 1):
	var spade = SPADE_BULLET.instance()
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
#	Kinda bad I'm not explaining this one for now. Oh well.
	var degree := rad2deg(radian) - (DIFF_DISTANCE * 2)
	
	for x in 5:
		create_spade(degree, 168, 5)
		degree += DIFF_DISTANCE
	
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
