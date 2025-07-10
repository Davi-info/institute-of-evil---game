extends Sprite2D

signal button_pressed(index)

func pressed():
	frame = 13 #2
	owner.push_rune(get_index())
	#emit_signal("button_pressed", get_index())

func unpressed():
	frame = 9 #1


func _on_player_entered(body):
	pressed()


func _on_player_exited(body):
	unpressed()
