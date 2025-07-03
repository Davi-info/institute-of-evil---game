extends Node2D

func _ready():
	$Area2D.body_entered.connect(_on_area_body_entered)
	$Area2D.body_exited.connect(_on_area_body_exited)

func _on_area_body_entered(body):
	if body is Player:
		body._on_trash_bin_area_entered($Area2D)

func _on_area_body_exited(body):
	if body is Player:
		body._on_trash_bin_area_exited($Area2D)
