extends Resource
class_name CharacterPanel

const COMMAND_BUTTON := ["", preload("res://src/scenes/battle/player/panel/BD_FIGHT.tres"),
preload("res://src/scenes/battle/player/panel/BD_ACT.tres"),
preload("res://src/scenes/battle/player/panel/BD_MAGIC.tres"),
preload("res://src/scenes/battle/player/panel/BD_ITEM.tres"),
preload("res://src/scenes/battle/player/panel/BD_SPARE.tres"),
preload("res://src/scenes/battle/player/panel/BD_DEFEND.tres")]

export(Texture) var icon = null
export(Texture) var hurt_icon = null
export(Texture) var character_name = null
export(Color) var border_color = Color(1,1,1,1) # Border
export(Color) var icon_color = Color(1,1,1,1)
export(Array) var commands

#func _init(dict: Dictionary):
#	if !dict.has_all(["icon", "hurt_icon", "character_name",
#	"border_color", "icon_color", "commands"]):
#		print("Error: panel will not load because it does not have the enough data.")
#		return
#	icon = dict["icon"]
#	hurt_icon = dict["hurt_icon"]
#	character_name = dict["character_name"]
#	border_color = dict["border_color"]
#	icon_color = dict["icon_color"]
#	if dict["commands"] == []:
#		commands.append(COMMAND_BUTTON[1])
#		commands.append(COMMAND_BUTTON[5])
#	else:
#		for command in dict["commands"]:
#			commands.append(COMMAND_BUTTON[command])

func _init(p_icon: Texture = null, p_hurt: Texture = null,
p_name: Texture = null, p_border := Color(1,1,1,1),
p_command_c := Color(1,1,1,1), p_commands := []):
	icon = p_icon
	hurt_icon = p_hurt
	character_name = p_name
	border_color = p_border
	icon_color = p_command_c
	if p_commands == []:
		p_commands = [1, 5]
	for command in p_commands:
		commands.append(COMMAND_BUTTON[command])
