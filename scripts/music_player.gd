extends Node2D

func play_music():
	$MusicMenu.play()

func stop_music():
		$Music.stop()
	
func on_button_pressed(button: Button) -> void:
	match button.name:
		'Play':
			MusicMenu.stop()  # Para a música antes de trocar de cena
			var _game: bool = get_tree().change_scene_to_file("res://levels/level_1.tscn")
		'Controls':
			var _controls: bool = get_tree().change_scene_to_file("res://interface/controls_view.tscn")
		'Exit':
			get_tree().quit()
