extends Node2D

func _ready() -> void:
	MusicMenu.stop_music()
	GameState.fase_atual = "fase3"  # ou "fase2", "fase3" conforme a cena
