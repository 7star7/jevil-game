extends Control

const button_base = preload("res://src/scenes/battle/player/panel/BT_P_PANEL_B.tscn")
const new_line = preload("res://src/scenes/battle/player/panel/BT_P_PANEL_L.tscn")
const sfx_squeak = preload("res://src/sound/effects/SFX_UT_SQUEAK.wav")
const sfx_accept = preload("res://src/sound/effects/SFX_UT_ACCEPT.wav")
#"res://src/sound/effects/SFX_DR_BOMB.wav"

signal command_selected(id)
signal cancelling
# warning-ignore:unused_signal
signal got_hit

# Same as the battle scene. It's here for reference.
enum SelectedCommand {
	NONE,
	FIGHT,
	ACT,
	MAGIC,
	ITEM,
	SPARE,
	DEFEND,
	SPECIAL
}

var command_icons = [preload("res://src/sprites/battle/ICON_FIGHT.png"),
preload("res://src/sprites/battle/ICON_FIGHT.png"),
preload("res://src/sprites/battle/ICON_ACT.png"),
preload("res://src/sprites/battle/ICON_MAGIC.png"),
preload("res://src/sprites/battle/ICON_ITEM.png"),
preload("res://src/sprites/battle/ICON_SPARE.png"),
preload("res://src/sprites/battle/ICON_DEFEND.png")]
var character_icons = []

onready var background = $Command/Background
onready var command_list = $Command/VContainer/HContainer
var button_array = []
onready var tween = $Tween

var health = 62 setget _set_health
var max_health = 62 setget _set_max_health

var activated := false setget _set_activated # When it's the panel's turn
var selected := false # When a command has been selected
#var show_button := false
var last_selected := 0 # The index of last button selected

var debug_mode := false
var camera_debug = Camera2D.new()

#var line = ColorRect.new()
var line_timer := 0
var line_timer_l := 40
var line_color := Color(1,1,1,1)

export var character: Resource = null

func _set_health(value):
	health = value
	$Info/HealthBar.value = health
	$Info/TexHealth.text = str(health)

func _set_max_health(value):
	max_health = value
	$Info/HealthBar.max_value = max_health
	$Info/MaxHealth.text = str(max_health)
	health = int(min(health, max_health))

func _set_activated(value):
	activated = value
	if activated:
		_on_self_activating(last_selected)
	else:
		_on_self_deactivating()

func new_styleboxflat(b_color):
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0,0,0,1)
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.border_width_top = 2
	sb.border_color = b_color
	return sb

func new_barflat(b_color):
	var sb = StyleBoxFlat.new()
	sb.bg_color = b_color
	return sb

func assign_character(dataset):
	if dataset != null:
		character_icons.clear()
		character_icons.insert(character_icons.size(), dataset.icon)
		if dataset.hurt_icon != null:
			character_icons.insert(character_icons.size(), dataset.hurt_icon)
		$Info/Icon/Head.texture = character_icons[0]
		
		$Info/Name.texture = dataset.character_name
		$Info/Icon/Command.modulate = dataset.icon_color
		line_color = dataset.border_color
		
		var new_sb = new_styleboxflat(dataset.border_color)
		$Info/Activated.set("custom_styles/panel", new_sb)
		$Command.set("custom_styles/panel", new_sb)
		
		var health_fg = new_barflat(dataset.border_color)
		$Info/HealthBar.set("custom_styles/fg", health_fg)
		
		for command in dataset.commands:
			var new_button = button_base.instance()
			new_button.dataset = command
			command_list.add_child(new_button)
			new_button.connect("pressed", self, "_on_Command_pressed")
			new_button.connect("focus_entered", self, "_on_Command_focus_entered")
			button_array.append(new_button)
		
		var new_split = HSplitContainer.new() # For the command menu
		new_split.size_flags_horizontal = SIZE_EXPAND_FILL
		command_list.add_child(new_split)
		new_split.name = "HSplit2"

func _ready():
	if get_parent().name == "root":
		debug_mode = true
		camera_debug.current = true
		camera_debug.position = Vector2(106.5, 18)
		add_child(camera_debug)
	
	# warning-ignore:return_value_discarded
	connect("cancelling", self, "_on_self_cancelling")
	
	assign_character(character)
	$Info/Icon/Command.hide()
	
	if command_list.get_child_count() <= 1:
		var test_button = button_base.instance()
		command_list.add_child(test_button)
		button_array.append(test_button)
		test_button.connect("pressed", self, "_on_Command_pressed")
		test_button.connect("focus_entered", self, "_on_Command_focus_entered")
	
#	for child in $Command/VContainer/HContainer.get_children():
#		if child.get_class() != "TextureButton":
#			continue
#		button_array.append(child)
	
	button_array[0].set_focus_neighbour(MARGIN_LEFT,
	button_array[0].get_path_to(button_array[-1]))
	button_array[-1].set_focus_neighbour(MARGIN_RIGHT,
	button_array[-1].get_path_to(button_array[0]))

func _physics_process(_delta):
	line_timer += 1
	if line_timer >= line_timer_l:
		line_timer = 0
		var line_l = new_line.instance()
		line_l.color = line_color
		background.add_child(line_l)
		var line_r = new_line.instance()
		line_r.direction = true
		line_r.color = line_color
		background.add_child(line_r)

func _process(_delta):
	if activated:
		$Info/Activated.show()
		$Info/Deactivated.hide()
	else:
		$Info/Activated.hide()
		$Info/Deactivated.show()
	
	if selected:
		$Info/Icon/Head.hide()
		$Info/Icon/Command.show()
	else:
		$Info/Icon/Head.show()
		$Info/Icon/Command.hide()

func _input(_event):
	if Input.is_action_just_pressed("debug_switch") and debug_mode:
		activated = !activated
		if activated:
			_on_self_activating()
		else:
			_on_self_deactivating()
	if Input.is_action_just_pressed("action_bomb") and activated and get_focus_owner() != null:
		emit_signal("cancelling")

func _on_self_activating(button_index := 0):
	tween.start()
	tween.interpolate_property($Info,
	"margin_top", null, -32, 0.3,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property($Info,
	"margin_bottom", null, 4, 0.3,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	button_array[button_index].grab_focus()

func _on_self_deactivating():
	tween.start()
	tween.interpolate_property($Info,
	"margin_top", null, 0, 0.3,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property($Info,
	"margin_bottom", null, 36, 0.3,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	for button in button_array:
		button.pressed = false
	if get_focus_owner() != null:
		get_focus_owner().release_focus()

func _on_self_cancelling():
	if get_index() == 1: # Technically it always works correctly.
		return
	activated = false
	selected = false
	for child in command_list.get_children():
		if child.get_class() == "TextureButton":
				child.pressed = false

func _on_Command_focus_entered():
	last_selected = get_focus_owner().get_index() - 1
	selected = false
	if get_focus_owner().pressed:
		get_focus_owner().pressed = false
	AudioPlayer.play_sfx(sfx_squeak, -1)

func _on_Command_pressed():
	var id
	if get_focus_owner() != null:
		id = get_focus_owner().id
	if id == null:
		return
	emit_signal("command_selected", id)
	$Info/Icon/Command.texture = command_icons[id]
	AudioPlayer.play_sfx(sfx_accept, 0)
