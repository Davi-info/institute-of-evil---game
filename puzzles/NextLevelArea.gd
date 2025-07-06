extends Area2D

@export var next_scene_path: String = "res://scenes/levels/level_2.tscn"

func _ready():
	# Conecta o sinal body_entered para detectar quando um corpo entra nesta área
	body_entered.connect(_on_body_entered)
	# Inicialmente, esta área deve estar desabilitada para que o jogador não possa passar antes da porta abrir
	monitorable = false # Não detecta corpos
	monitoring = false  # Não emite sinais
	print("NextLevelArea: Inicializado. Monitoramento desabilitado.")


func _on_body_entered(body):
	print("NextLevelArea: body_entered detectado. Corpo: ", body.name)
	if body.name == "Player": # Verifica se o corpo que entrou é o jogador
		print("NextLevelArea: Jogador detectado. Carregando próxima cena: ", next_scene_path)
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("NextLevelArea: Corpo não é o jogador. Nome: ", body.name)

# Função para habilitar a área de transição quando a porta for aberta
func enable_area():
	monitorable = true
	monitoring = true
	print("NextLevelArea: Área de transição para o próximo nível habilitada.")
