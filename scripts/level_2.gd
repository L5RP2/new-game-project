extends Node2D

func _ready():
	if global.game_first_loading == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_level_2_posx
		$player.position.y = global.player_exit_level_2_posy

func _process(_delta):
	change_scene()

func change_scene():
	if global.current_scene == "level_2":
		get_tree().change_scene_to_file("res://المشاهد/world.tscn")
		global.game_first_loading = false
		global.finish_change_scenes()


func _on_level_2_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func _on_level_2_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false
