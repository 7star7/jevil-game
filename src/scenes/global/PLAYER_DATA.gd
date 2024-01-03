extends Node

const SAVE_FILE := "user://save_file.dat"
#const STARWALKER := preload("res://src/sprites/starwalker.png")

## Dipper (weapon), outfit (armor) and item menus use ID
var default_data: Dictionary = {
	"name": "Flame",
	"level": 1,
	"exp": 0,
	"dipper": 0,
	"outfit": 0,
	"menu_item": [],
	"has_recipe": false,
	"recipe_page": 0,
	"menu_food": []
}

var current_data := default_data
#var sw_check = false
var custom_characters := []

func check_file():
	var file = File.new()
	if file.file_exists(SAVE_FILE):
		return true
	else: return false

func create_file(name: String):
	current_data = default_data
	current_data["name"] = name
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(current_data)
	file.close()

func save_file():
	var file = File.new()
	if file.file_exists(SAVE_FILE):
		file.open(SAVE_FILE, File.WRITE)
		file.store_var(current_data)
		file.close()

func load_file():
	var file = File.new()
	file.open(SAVE_FILE, File.READ)
	current_data = file.get_var()
	file.close()

func delete_file():
	var file = File.new()
	if file.file_exists(SAVE_FILE):
		var dir = Directory.new()
		if !dir.current_is_dir():
			dir.remove(SAVE_FILE)
	current_data = default_data

func get_json_files_from_folder(path: String):
	var files := []
	var dir := Directory.new()
	if dir.open(path):
		return
	# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.ends_with(".json"):
			continue
		elif !file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files

func _init():
#	var check_for_mods = false
#	var file = File.new()
#	check_for_mods = file.file_exists("Aya.png")
#	if check_for_mods:
#		sw_check = true
	
	var json_mods = get_json_files_from_folder("mods")
	if json_mods == null:
		return
	
	for og_json_file in json_mods:
		var new_character := {}
		var new_pp := []
		var j_direction = "mods/" + og_json_file
		var f_path = j_direction
		f_path.erase(f_path.length() - 5, 5)
		var j_file = File.new()
		j_file.open(j_direction, File.READ)
		var data = parse_json(j_file.get_as_text())
		
		for key in data.keys():
			match key:
				"name", "lv", "health", "attack", "defense", "magic", "guts":
					new_character[key] = (data[key])
				"icon", "hurt_icon", "character_name":
					var i_file = File.new()
					if i_file.open(f_path + '/' + data[key], File.READ):
						print("Fuck.")
					var bytes = i_file.get_buffer(i_file.get_len())
					var img = Image.new()
					img.load_png_from_buffer(bytes)
					var tex = ImageTexture.new()
					tex.create_from_image(img)
					new_pp.append(tex)
				"border_color", "icon_color":
					var new_color = Color(data[key][0],
					data[key][1], data[key][2],
					data[key][3])
					new_pp.append(new_color)
		
		if "commands" in data:
			new_character["panel_data"] = CharacterPanel.new(new_pp[0],
			new_pp[1], new_pp[2], new_pp[3], new_pp[4], data["commands"])
		
		custom_characters.append(new_character)

#func _ready():
#	if sw_check:
#		var sw = Sprite.new()
#		sw.centered = false
#		sw.z_index = 10
#		sw.texture = STARWALKER
#		add_child(sw)
