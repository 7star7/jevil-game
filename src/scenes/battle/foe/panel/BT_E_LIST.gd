extends HBoxContainer

const sfx_squeak = preload("res://src/sound/effects/SFX_UT_SQUEAK.wav")
const sfx_accept = preload("res://src/sound/effects/SFX_UT_ACCEPT.wav")

signal cancelling

var enemy_owner
var health := 100 setget _set_health
var max_health := 100 setget _set_max_health

func _set_health(value):
	if value > max_health:
		value = max_health
	health = value
	$ControlBar/Health.value = value

func _set_max_health(value):
	max_health = value
	if health > max_health:
		health = max_health
	$ControlBar/Health.max_value = value

func _ready():
	if enemy_owner != null:
		$EnemyName.text = enemy_owner.enemy_name
		name = "Entry" + enemy_owner.name
		_set_max_health(enemy_owner.max_health)
		_set_health(enemy_owner.health)

func _input(_event):
	if Input.is_action_just_pressed("action_bomb") and $Soul.has_focus():
		emit_signal("cancelling")

func _on_Soul_focus_entered():
	AudioPlayer.play_sfx(sfx_squeak, 0)
	enemy_owner.get_node("ShaderManager").play("selected")

func _on_Soul_focus_exited():
	enemy_owner.get_node("ShaderManager").play("none")

func _on_Soul_pressed():
	AudioPlayer.play_sfx(sfx_accept, 0)
