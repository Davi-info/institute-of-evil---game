extends Node2D


func _ready() -> void:
	GameState.fase_atual = "fase1"  # ou "fase2", etc
	#GameState.accs_coletadas = 0

	var hud_scene = preload("res://interface/HUD.tscn")
	var hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)
