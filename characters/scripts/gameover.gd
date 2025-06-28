extends Control

func _ready():
	pass
	
func _process(delta: float):
	pass


func _on_restart_pressed() -> void:	
	GameState.reset()
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


func _on_sair_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/main_menu.tscn")
