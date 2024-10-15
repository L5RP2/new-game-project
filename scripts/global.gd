extends Node
var player_current_attack = false
var current_scene = "world"  # أو cliff_side
var transition_scene = false

var player_exit_level_2_posx = 510
var player_exit_level_2_posy = 176
var player_start_posx = -29
var player_start_posy = 126

var game_first_loadin = true

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "level_2"
		else:
			current_scene = "world"
