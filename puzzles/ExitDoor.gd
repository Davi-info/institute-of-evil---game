extends StaticBody2D

@onready var next_level_area = $"../NextLevelArea" # Caminho relativo para o NextLevelArea

func _ready():
	GameManager.all_accs_collected.connect(_on_all_accs_collected)
	# Garante que a porta está fechada no início
	# Se você usa queue_free(), o nó ExitDoor é o que representa a porta fechada
	# e ele será removido.

func _on_all_accs_collected():
	print("Todos os ACCs coletados! Abrindo a porta de saída.")
	open_door()

func open_door():
	# Habilita a área de transição para o próximo nível
	if next_level_area: # Verifica se o nó existe
		next_level_area.enable_area()
	# Remove a porta da cena, liberando completamente o caminho
	queue_free()
	print("Porta aberta!")
