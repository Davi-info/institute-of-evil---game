extends Node2D

func _ready() -> void:
	GameState.fase_atual = "fase1"  # ou "fase2", etc
	#GameState.accs_coletadas = 0
	
	MusicMenu.stop_music()
	
	var hud_scene = preload("res://interface/hud.tscn")
	var hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)

func _unhandled_input(event: InputEvent) -> void:
	# Verifica se um diálogo já está em execução
	if Dialogic.current_timeline != null:
		return

	# Verifica se a tecla Enter foi pressionada
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		Dialogic.start('timeline')
		get_viewport().set_input_as_handled()
