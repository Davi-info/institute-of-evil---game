extends Node2D

func _ready() -> void:
	GameState.fase_atual = "fase1"  # ou "fase2", etc
	GameManager.reset_game_state()
	Dialogic.start("timeline")
	
	MusicMenu.stop_music()
	
	var hud_scene = preload("res://scenes/interface/hud.tscn")
	var hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)
