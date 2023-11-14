extends Control

const sfx_accept = preload("res://src/sound/effects/SFX_UT_ACCEPT.wav")

onready var tween = $Tween
onready var battle_button = $ButtonLayer/BattleButton
onready var edit_button = $ButtonLayer/EditButton
onready var quit_button = $ButtonLayer/QuitButton
onready var ki_tan = get_tree()

func _ready():
	battle_button.grab_focus()

func _on_Button_focus_entered():
	if get_focus_owner() != null:
		if get_focus_owner().has_node("HeartPos"):
			tween.start()
			tween.interpolate_property($Soul, "global_position",
			null, get_focus_owner().get_node("HeartPos").global_position,
			0.35, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)

func _on_BattleButton_pressed():
	AudioPlayer.play_sfx(sfx_accept)
	ki_tan.change_scene("res://src/scenes/battle/BATTLE_SCENE.tscn")

func _on_EditButton_pressed():
	AudioPlayer.play_sfx(sfx_accept)
	pass

func _on_QuitButton_pressed():
	AudioPlayer.play_sfx(sfx_accept)
	ki_tan.quit()
