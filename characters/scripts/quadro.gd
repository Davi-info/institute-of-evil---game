extends Node2D

@export var timeline_path := "res://Timeline/quadro.dtl"

var player_na_area := false

func _process(delta: float) -> void:
	if player_na_area and Input.is_action_just_pressed("interact"):
		Dialogic.start(timeline_path)

func _on_body_entered(body):
	if body.name == "Player":
		player_na_area = true
		print("Player entrou")

func _on_body_exited(body):
	if body.name == "Player":
		player_na_area = false
		print("Player saiu")
