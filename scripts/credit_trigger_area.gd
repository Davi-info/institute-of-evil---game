extends Area2D

@export var delay_time: float = 2.0
@export var credits_scene_path: String = "res://scenes/interface/gameclear.tscn"

var player_inside := false

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if player_inside:
		return
	if not body.is_in_group("player"):
		return

	var diretor = get_tree().get_first_node_in_group("diretor")
	if diretor == null:
		print("Erro: Diretor não encontrado.")
		return

	if diretor.foi_libertado:
		player_inside = true
		print("Player entrou na área após libertar o diretor. Esperando para exibir créditos...")
		await get_tree().create_timer(delay_time).timeout
		get_tree().change_scene_to_file(credits_scene_path)
	else:
		print("Diretor ainda não foi libertado.")
