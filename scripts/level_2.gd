extends Node2D

func _ready() -> void:
	MusicMenu.stop_music()
	GameState.fase_atual = "fase2"
	Dialogic.start("timfala_fase2")
	
	var hud_scene = preload("res://scenes/interface/hud.tscn")
	var hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)
