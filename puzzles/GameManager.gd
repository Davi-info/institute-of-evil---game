extends Node

var collected_accs = 0
var total_accs = 3

signal acc_collected(current_accs)
signal all_accs_collected

func _ready():
	pass # Pode ser usado para inicializações futuras

func collect_acc():
	collected_accs += 1
	emit_signal("acc_collected", collected_accs)
	if collected_accs >= total_accs:
		emit_signal("all_accs_collected")

func get_collected_accs():
	return collected_accs

func get_total_accs():
	return total_accs

func reset_game_state():
	collected_accs = 0
	emit_signal("acc_collected", collected_accs) # Para atualizar o HUD imediatamente
	print("GameManager: Estado do jogo resetado. ACCs: ", collected_accs)
