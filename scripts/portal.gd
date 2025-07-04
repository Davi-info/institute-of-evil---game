extends Area2D

@export var portal_aberto := true

var jogador_perto := false
var jogador_ref: Node2D = null

func _ready():
	visible = portal_aberto
	set_collision_layer_value(1, portal_aberto)
	set_collision_mask_value(1, portal_aberto)

func _process(_delta):
	if portal_aberto and jogador_perto and Input.is_action_just_pressed("interact"):
		ir_para_proxima_fase()

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		jogador_perto = true
		jogador_ref = body

func _on_body_exited(body: Node2D):
	if body == jogador_ref:
		jogador_perto = false
		jogador_ref = null

func ir_para_proxima_fase():
	var cena_atual_path = get_tree().current_scene.scene_file_path
	var regex = RegEx.new()
	regex.compile("level_(\\d+)\\.tscn")
	var match = regex.search(cena_atual_path)
	if match:
		var numero_fase = int(match.get_string(1))
		var proxima_fase_numero = numero_fase + 1
		var proxima_fase_path = "res://scenes/levels/level_%d.tscn" % proxima_fase_numero

		if ResourceLoader.exists(proxima_fase_path):
			var proxima_fase = load(proxima_fase_path)
			get_tree().change_scene_to_packed(proxima_fase)
		else:
			print("Fim do jogo ou fase não encontrada:", proxima_fase_path)
	else:
		print("Nome da fase atual não segue o padrão esperado.")
