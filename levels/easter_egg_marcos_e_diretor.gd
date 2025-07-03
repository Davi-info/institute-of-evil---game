extends Node2D  

var player_na_area = false
var player_ref = null
@export var mensagem: String = "É um quadro antigo... parece importante."

func _ready():
	var area = get_node_or_null("DetectionArea")
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player" or body is Player:
		player_na_area = true
		player_ref = body
		print("Player detectado no quadro")

func _on_body_exited(body):
	if body == player_ref:
		player_na_area = false
		player_ref = null
		print("Player saiu da área do quadro")

func _process(delta):
	if player_na_area and Input.is_action_just_pressed("interact"):
		print("Tentando exibir mensagem...")
		exibir_mensagem()

func exibir_mensagem():
	var hud = get_tree().current_scene.get_node_or_null("HUD2")  # Mudou de "HUD" para "HUD2"
	if hud and hud.has_method("mostrar_mensagem"):
		hud.mostrar_mensagem(mensagem)
	else:
		print("HUD2 ou função mostrar_mensagem não encontrada!")
