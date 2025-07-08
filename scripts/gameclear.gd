extends Control

func _ready():
	$AnimationPlayer.play("show_credits")
	
func go_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/interface/main_menu.tscn")
