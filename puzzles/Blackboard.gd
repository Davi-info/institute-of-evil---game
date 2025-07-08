# Blackboard.gd
extends StaticBody2D

@onready var interaction_area = $InteractionArea

# Preload da cena da UI do quiz
var quiz_ui_scene = preload("res://scenes/ui/quiz_ui.tscn")

var player_in_range = false
var quiz_solved = false # Para garantir que o quiz só seja resolvido uma vez

func _ready():
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)

func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		print("Player perto da lousa. Pressione 'E' para interagir.")

func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		print("Player saiu da área da lousa.")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not quiz_solved:
		open_quiz_dialog()

func open_quiz_dialog():
	if quiz_solved: return

	var quiz_ui = quiz_ui_scene.instantiate()
	get_tree().root.add_child(quiz_ui)

	# Conecta o sinal da UI para receber a resposta do quiz
	quiz_ui.quiz_answered.connect(_on_quiz_answered)

func _on_quiz_answered(is_correct: bool):
	if is_correct:
		print("Quiz resolvido corretamente!")
		quiz_solved = true
		release_acc3()
	else:
		print("Resposta incorreta. Tente novamente.")
		# Opcional: feedback visual/sonoro de erro, ou permitir múltiplas tentativas

func release_acc3():
	# Aqui você faria o ACC3 aparecer ou ser coletado
	var acc3_node = get_tree().current_scene.get_node_or_null("acc3") # Ou o nome do seu ACC3
	if acc3_node:
		acc3_node.visible = true
		acc3_node.enable_acc() # Habilita o Area2D do ACC
		print("ACC3 liberado do quiz!")
	else:
		print("Erro: Nó ACC3 não encontrado na cena para ser liberado.")
