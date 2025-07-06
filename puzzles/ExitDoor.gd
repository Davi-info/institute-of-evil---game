# ExitDoor.gd
extends StaticBody2D

@onready var next_level_area = $"../NextLevelArea"

func _ready():
	GameManager.all_accs_collected.connect(_on_all_accs_collected)
	print("ExitDoor: next_level_area encontrado? ", next_level_area != null) # Adicione esta linha

func _on_all_accs_collected():
	print("Todos os ACCs coletados! Abrindo a porta de saída.")
	open_door()

func open_door():
	if next_level_area:
		next_level_area.enable_area()
		print("ExitDoor: Chamou enable_area() no NextLevelArea.") # Adicione esta linha
	else:
		print("ExitDoor: ERRO! next_level_area é nulo. Não foi possível habilitar a área de transição.") # Adicione esta linha
	queue_free()
	print("Porta aberta!")
