extends Area2D

var player_na_area = false
var player_ref = null
@export var timeline_name: String = "diretor"  # Nome do timeline que você criou

func _ready():
	pass

func _process(float) -> void:
	if player_na_area and Input.is_action_just_pressed("interact"):
		print("Iniciando diálogo com Dialogic...")
		iniciar_dialogo()

func iniciar_dialogo():
	# Inicia o timeline do Dialogic
	Dialogic.start("res://timeline/diretor.dtl")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is Player:
		player_na_area = true
		player_ref = body
		print("Player detectado diretor")

func _on_body_exited(body: Node2D) -> void:
	if body == player_ref:
		player_na_area = false
		player_ref = null
		print("Player saiu da área do diretor")
