extends CanvasLayer

@onready var tentativas_label = $TentativasLabel
#@onready var accs_label = $AccsLabel

func _ready() -> void:
	atualizar_hud()

func atualizar_hud() -> void:
	tentativas_label.text = "❤️ %d" % GameState.tentativas 
	#accs_label.text = "📜 %d" % GameState.accs_coletadas

func atualizar_tentativas() -> void:
	tentativas_label.text = "❤️ %d" % GameState.tentativas 

#func atualizar_accs() -> void:
#	accs_label.text = "📜 %d" % GameState.accs_coletadas
