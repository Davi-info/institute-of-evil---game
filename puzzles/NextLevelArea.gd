extends Area2D

@export var next_scene_path: String = "res://scenes/levels/level_2.tscn"

func _ready():
	# Conecta o sinal body_entered para detectar quando um corpo entra nesta área
	body_entered.connect(_on_body_entered)
	# Inicialmente, esta área deve estar desabilitada para que o jogador não possa passar antes da porta abrir
	monitorable = false # Não detecta corpos
	monitoring = false  # Não emite sinais

func _on_body_entered(body):
	if body.name == "Player": # Verifica se o corpo que entrou é o jogador
		print("Jogador entrou na área de transição. Carregando próxima cena...")
		# Carrega a próxima cena
		get_tree().change_scene_to_file(next_scene_path)

# Função para habilitar a área de transição quando a porta for aberta
func enable_area():
	monitorable = true
	monitoring = true
	print("Área de transição para o próximo nível habilitada.")
