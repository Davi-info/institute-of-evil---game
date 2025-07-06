# ExitDoor.gd
extends StaticBody2D

@onready var interact_area = $InteractArea
@onready var next_level_area = $"../NextLevelArea"
@onready var player = get_tree().get_first_node_in_group("player") # ou use get_node se souber o caminho

var door_unlocked := false

func _ready():
	GameManager.all_accs_collected.connect(_on_all_accs_collected)
	interact_area.body_entered.connect(_on_body_entered)


func _on_all_accs_collected():
	print("Todos os ACCs coletados! Abrindo a porta de saída.")
	door_unlocked = true
	open_door()

func open_door():
	if next_level_area:
		next_level_area.enable_area()
		print("ExitDoor: Chamou enable_area() no NextLevelArea.") # Adicione esta linha
	else:
		print("ExitDoor: ERRO! next_level_area é nulo. Não foi possível habilitar a área de transição.") # Adicione esta linha
	queue_free()
	print("Porta aberta!")

func _on_body_entered(body):
	if body.name != "Player":
		return

	if not door_unlocked:
		print("Jogador tentou sair sem coletar tudo. Mostrando diálogo.")
		Dialogic.start("warning_not_all_items")  # Nome da timeline no Dialogic
	else:
		print("Jogador entrou na porta já desbloqueada.")
