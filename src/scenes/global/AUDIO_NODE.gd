extends AudioStreamPlayer
onready var NEW_SFX
onready var VOLUMEN

func _ready():
	volume_db = VOLUMEN
	stream = NEW_SFX
	play()

func _on_SFXPlayer_finished():
	queue_free()
