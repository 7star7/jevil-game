extends Node

const player_panel = preload("res://src/scenes/battle/player/panel/BT_P_PANEL.tscn")
const enemy_entry = preload("res://src/scenes/battle/foe/panel/BT_E_LIST.tscn")
const attack_placeholder = preload("res://src/scenes/battle/attack/AT_PLACEHOLDER.tscn")
const attack_club = preload("res://src/scenes/battle/attack/AT_JV_BOMB_C.tscn")
const attack_diamond = preload("res://src/scenes/battle/attack/AT_JV_BOMB_D.tscn")
const attack_heart = preload("res://src/scenes/battle/attack/AT_JV_BOMB_H.tscn")
const attack_diamond_b = preload("res://src/scenes/battle/attack/AT_JV_DIAM_BT.tscn")

enum {
	DONE,
	FIGHT,
	ACT,
	MAGIC,
	ITEM,
	SPARE,
	DEFEND,
	SPECIAL
}

onready var player_menu = $BottomInterface/PlayerMenu/HContainer
onready var enemy_list = $BottomInterface/TextZone/EnemyList
onready var soul = $AttackLayer/Soul

var tension_points := 0.0
var battling := false
var battle_timer := 0.0

var members_ready: int = 0
var players_actions := [DONE, DONE, DONE]

var current_party := CharacterData.current_party
var members_panels := []
var attacks := [attack_placeholder, attack_club, attack_diamond, attack_heart,
attack_diamond_b]

func do_attack(attack):
	var new_attack = attack.instance()
	new_attack.position = Vector2(321, 171)
	$AttackLayer.add_child(new_attack)

func add_member(member):
	var current_level = member["lv"]
	var new_panel = player_panel.instance()
	new_panel.character = member["panel_data"]
	new_panel._set_max_health(member["health"][current_level - 1])
	new_panel._set_health(new_panel.max_health)
	player_menu.add_child(new_panel)
	if member["name"] != null:
		new_panel.name = member["name"] + "Panel"
	return new_panel

func add_enemy_entry(enemy):
	var new_entry = enemy_entry.instance()
	new_entry.enemy_owner = enemy
	enemy_list.add_child(new_entry)
	new_entry.set_focus_neighbour(MARGIN_LEFT,
	new_entry.get_path_to(new_entry))
	new_entry.set_focus_neighbour(MARGIN_RIGHT,
	new_entry.get_path_to(new_entry))

func set_focus_for_enemy_list():
	var array_enemy = enemy_list.get_children()
	array_enemy[0].get_node("Soul").set_focus_neighbour(MARGIN_TOP,
	array_enemy[0].get_node("Soul").get_path_to(array_enemy[-1].get_node("Soul")))
	array_enemy[-1].get_node("Soul").set_focus_neighbour(MARGIN_BOTTOM,
	array_enemy[-1].get_node("Soul").get_path_to(array_enemy[0].get_node("Soul")))

func setup_players(party: Array):
	match party.size():
		1:
			members_panels.append(add_member(party[0]))
			
			var split = HSplitContainer.new()
			split.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			player_menu.add_child(split)
			split.name = "HSplit2"
		2:
			members_panels.append(add_member(party[0]))
			
			var middle_split = HSplitContainer.new()
			middle_split.rect_min_size.x = 35
			player_menu.add_child(middle_split)
			middle_split.name = "HSplit2"
			
			members_panels.append(add_member(party[1]))
			
			var end_split = HSplitContainer.new()
			end_split.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			player_menu.add_child(end_split)
			end_split.name = "HSplit3"
		3:
			for member in party.size():
				members_panels.append(add_member(party[member]))
		_:
			print("Error: Incorrect party size.")
			return
	while players_actions.size() > party.size():
		players_actions.pop_back()

func setup_enemies():
	for child in $EnemyLayer.get_children():
		add_enemy_entry(child)
	for child in enemy_list.get_children():
		child.connect("cancelling", self, "_on_EnemyEntry_cancelling")
		child.get_node("Soul").connect("pressed", self, "_on_EnemyEntry_pressed")
	set_focus_for_enemy_list()

func readying_panels(command_id: int):
	players_actions[members_ready] = command_id
	if $BottomInterface.get_focus_owner() != null:
		$BottomInterface.get_focus_owner().release_focus()
	members_panels[members_ready].selected = true
	for panel in members_panels:
		panel.activated = false

func check_next_panel():
	members_ready += 1
	if members_ready >= current_party.size():
		for member in members_panels:
			member.last_selected = 0
		members_ready = 0
		player_turn()
		return
	members_panels[members_ready].activated = true

func player_turn():
	# Check for act and magic
	for action in players_actions.size():
		if players_actions[action] == FIGHT:
			players_actions[action] = DONE
	enemy_turn()

func enemy_turn():
	if $EnemyLayer.get_child_count() <= 4:
		do_attack(attacks[randi() % attacks.size()])
		soul.show()
		soul.position = Vector2(321, 171)
		battle_timer = 20.0
		battling = true
	$Background/Darker.show()

func _ready():
	if PlayerData.custom_characters != []:
		current_party = PlayerData.custom_characters
	setup_players(current_party)
	setup_enemies()
	members_panels[0].activated = true
	for member in members_panels:
		member.connect("command_selected", self, "_on_Panel_command_selected")
		member.connect("cancelling", self, "_on_Panel_cancelling")
	randomize()
	soul.hide()

func _process(delta):
	battle_timer = max(battle_timer - delta, 0)
	if battle_timer <= 0 and battling:
		battling = false
		$Background/Darker.hide()
		soul.hide()
		for child in $AttackLayer.get_children():
			if child.name != "Soul":
				child.attack_done()
		members_panels[0].activated = true
		for panel in members_panels:
			panel.selected = false
	
	if battling:
		$BottomInterface/TextZone.hide()
	else:
		$BottomInterface/TextZone.show()
	
	$TensionBar.tension_points = tension_points
	if soul.visible: BattleGlobal.player_position = soul.global_position

func _on_Soul_grazed():
	tension_points = min(tension_points + 6, 250)
	battle_timer = max(battle_timer - 0.05, 0)

func _on_Panel_command_selected(id):
	match id:
		FIGHT, ACT, SPARE:
			enemy_list.show()
			$BottomInterface/TextZone/Label.hide()
			$BottomInterface/TextZone/Asterix.hide()
			enemy_list.get_child(0).get_node("Soul").grab_focus()
			return
		MAGIC:
#			magic_list.show()
			pass
		ITEM:
#			item_list.show()
			pass
	
	readying_panels(id)
	check_next_panel()

func _on_Panel_cancelling():
	yield(get_tree().create_timer(0.01), "timeout")
	members_ready -= 1
	if members_ready < 0: # Technically it always works correctly.
		members_ready = 0
		return
	for panel in members_panels:
		panel.activated = false
	players_actions[members_ready] = DONE
	members_panels[members_ready].activated = true

func _on_EnemyEntry_pressed():
	$BottomInterface/TextZone.get_focus_owner().release_focus()
	enemy_list.hide()
	$BottomInterface/TextZone/Label.show()
	$BottomInterface/TextZone/Asterix.show()
	yield(get_tree().create_timer(0.01), "timeout")
	
	var current_member = members_panels[members_ready]
	readying_panels(current_member.button_array[current_member.last_selected].id)
	check_next_panel()

func _on_EnemyEntry_cancelling():
	$BottomInterface/TextZone.get_focus_owner().release_focus()
	enemy_list.hide()
	$BottomInterface/TextZone/Label.show()
	$BottomInterface/TextZone/Asterix.show()
	yield(get_tree().create_timer(0.01), "timeout")
	players_actions[members_ready] = DONE
	members_panels[members_ready].activated = true
