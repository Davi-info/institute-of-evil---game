# Safe.gd
extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var safe_sprite = $Sprite2D

@export var correct_code: String = "472"
var player_in_range = false
var is_open = false

# Preload da cena da UI do cofre
var safe_input_ui_scene = preload("res://scenes/safe_input_ui.tscn")

func _ready():
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)

func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		print("Player perto do cofre. Pressione 'E' para interagir.")

func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		print("Player saiu da área do cofre.")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_open:
		open_safe_dialog()

func open_safe_dialog():
	if is_open: return # Não abre se já estiver aberto

	var safe_input_ui = safe_input_ui_scene.instantiate()
	get_tree().root.add_child(safe_input_ui) # Adiciona a UI diretamente ao root para garantir que apareça sobre tudo

	# Conecta o sinal da UI para receber o código digitado
	safe_input_ui.code_entered.connect(_on_code_entered)

func _on_code_entered(code_text: String):
	if code_text == correct_code:
		print("Código correto!")
		is_open = true
		release_acc1()
	else:
		print("Código incorreto. Tente novamente.")
		# Opcional: feedback visual/sonoro de erro
		# Você pode reabrir o diálogo ou dar uma nova chance

func release_acc1():
	var acc1_node = get_tree().current_scene.get_node_or_null("acc")
	if acc1_node:
		acc1_node.visible = true
		# Se o ACC já tem script de coleta, ele será coletado quando o jogador tocar
		# Se não, você pode chamar GameManager.collect_acc() aqui diretamente
		print("ACC1 liberado do cofre!")
	else:
		print("Erro: Nó ACC1 não encontrado na cena para ser liberado.")
