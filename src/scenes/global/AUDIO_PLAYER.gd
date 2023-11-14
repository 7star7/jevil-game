extends Node

const new_sfx = preload("res://src/scenes/global/AUDIO_NODE.tscn")
#Prefer preload sounds in the corresponding scene's script.

# So it just adds audio stream children to itself.
# Then after the audio is done, each one quit by itself.
func play_sfx(sfx, volumen = -10):
	var audio = new_sfx.instance()
	audio.VOLUMEN = volumen
	audio.NEW_SFX = sfx
	self.add_child(audio)
