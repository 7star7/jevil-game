extends Control
const sfx_squeak = preload("res://assets/sound/effects/SFX_UT_SQUEAK.wav")
const sfx_accept = preload("res://assets/sound/effects/SFX_UT_ACCEPT.wav")

onready var file_name = $FileName
onready var file_level = $FileLove
onready var ki_tan = get_tree()

var no_file = "File not found"

func _ready():
	if PlayerData.check_file():
		PlayerData.load_file()
	$StartButton.grab_focus()

func _process(_delta):
	if PlayerData.check_file():
		file_level.show()
		file_name.text = PlayerData.current_data.name
		file_level.text = "LV " + str(PlayerData.current_data.level)
	else:
		file_level.hide()
		file_name.text = no_file

func _on_focus_entered():
	AudioPlayer.play_sfx(sfx_squeak)

func _on_StartButton_pressed():
	AudioPlayer.play_sfx(sfx_accept)
	if $NameTest.text != "" and !PlayerData.check_file():
		PlayerData.create_file($NameTest.text)
	ki_tan.change_scene("res://src/scenes/battle/BATTLE_SCENE.tscn")

func _on_DeleteButton_pressed():
	AudioPlayer.play_sfx(sfx_accept)
	PlayerData.delete_file()

func _on_ExitButton_pressed():
	AudioPlayer.play_sfx(sfx_accept)
	ki_tan.quit()

func _on_NameTest_text_changed(new_text):
	if new_text.to_upper() == "GASTER":
		ki_tan.quit()
