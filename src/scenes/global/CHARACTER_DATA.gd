extends Node

var kris_data: Dictionary = {
	"name": "Kris",
	"lv": 1,
	"health": [90, 120, 160],
	"attack": [10, 12, 14],
	"defense": [2, 2, 2],
	"magic": [0, 0, 0],
	"guts": [1, 2, 2],
	"panel_data": preload("res://src/scenes/battle/player/panel/PP_KRIS.tres")
}

var susie_data: Dictionary = {
	"name": "Susie",
	"lv": 1,
	"health": [110, 140, 190],
	"attack": [14, 16, 18],
	"defense": [2, 2, 2],
	"magic": [1, 1, 3],
	"guts": [2, 2, 2],
	"panel_data": preload("res://src/scenes/battle/player/panel/PP_SUSIE.tres")
}

var ralsei_data: Dictionary = {
	"name": "Ralsei",
	"lv": 1,
	"health": [70, 100, 140],
	"attack": [8, 10, 12],
	"defense": [2, 2, 2],
	"magic": [7, 9, 11],
	"guts": [0, 0, 0],
	"panel_data": preload("res://src/scenes/battle/player/panel/PP_RALSEI.tres")
}

var noelle_data: Dictionary = {
	"name": "Noelle",
	"lv": 1,
	"health": [60, 90, 130],
	"attack": [1, 3, 5],
	"defense": [0, 1, 2],
	"magic": [9, 11, 13],
	"guts": [0, 0, 0],
	"panel_data": preload("res://src/scenes/battle/player/panel/PP_NOELLE.tres")
}

var current_party := [kris_data, kris_data]
