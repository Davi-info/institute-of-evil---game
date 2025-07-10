extends CanvasLayer # Se você mudou o tipo do HUD para CanvasLayer

@onready var acc_counter_label = $AccCounterLabel # Certifique-se que o nome aqui é EXATAMENTE o nome do nó na cena

func _ready():
	# Conecta o sinal 'acc_collected' do GameManager ao método '_on_acc_collected' deste script
	GameManager2.acc_collected.connect(_on_acc_collected)
	# Atualiza o texto inicial do contador
	_on_acc_collected(GameManager2.get_collected_accs())

func _on_acc_collected(current_accs):
	acc_counter_label.text = "📜 %s/%s" % [current_accs, GameManager2.get_total_accs()]
