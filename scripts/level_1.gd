extends Node2D

func _ready() -> void:
	MusicMenu.stop_music()
	GameState.fase_atual = "fase1"  # ou "fase2", etc
	#GameState.accs_coletadas = 0
	
	var hud_scene = preload("res://scenes/interface/hud.tscn")
	var hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)
	
	#var transition_scene = preload("res://interface/transition.tscn")
	#var transition = transition_scene.instantiate()
	#add_child(transition)
