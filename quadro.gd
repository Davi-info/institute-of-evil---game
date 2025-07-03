extends Area2D

var player_near = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "player":
		player_near = true

func _on_body_exited(body):
	if body.name == "player":
		player_near = false

func _unhandled_input(event):
	if player_near and event.is_action_pressed("interact"):
		show_message()

func show_message():
	print("👻 Marcos é o diretor!")
