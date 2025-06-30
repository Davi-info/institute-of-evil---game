extends AudioStreamPlayer2D

func play_music():
	play()

func stop_music():
	stop()
	
func _ready():
	MusicMenu.play_music()
	MusicControllerLvl.stop_music()
	
func on_button_pressed(button: Button) -> void:
	match button.name:
		'Play':
			MusicMenu.stop_music()
			get_tree().change_scene_to_file("res://levels/level_1.tscn")
		'Controls':
			get_tree().change_scene_to_file("res://interface/controls_view.tscn")
		'Exit':
			get_tree().quit()
