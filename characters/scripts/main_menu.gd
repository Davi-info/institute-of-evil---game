extends Control

func _ready():
	for button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(on_button_pressed.bind(button))
		button.mouse_exited.connect(mouse_interaction.bind(button, "exited"))
		button.mouse_entered.connect(mouse_interaction.bind(button, "entered"))

func on_button_pressed(button: Button) -> void:
	match button.name:
		'Play':
			var _game: bool = get_tree().change_scene_to_file("res://levels/level_1.tscn")
		'Controls':
			var _controls: bool = get_tree().change_scene_to_file("res://interface/controls_view.tscn")
		'Exit':
			get_tree().quit()

func mouse_interaction(button: Button, state: String) -> void:
	match state:
		'exited':
			button.modulate.a = 1.0
		'entered':
			button.modulate.a = 0.5
