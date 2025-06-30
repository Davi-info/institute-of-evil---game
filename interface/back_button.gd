extends Button

@export var scene_path: String

func _on_back_button_pressed() -> void:
	var _change_scene: bool = get_tree().change_scene_to_file(scene_path)

func _on_mouse_exited() -> void:
	modulate.a = 1.0

func _on_mouse_entered() -> void:
	$HouverSound.play()
	modulate.a = 0.5
