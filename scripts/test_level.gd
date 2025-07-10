extends Node # Ou o tipo de nó que seu test_level.tscn é

func _on_Button_button_pressed(index_do_botao):
	print("Botão com índice ", index_do_botao, " foi pressionado!")
	# Aqui você colocaria a lógica que antes estava em push_rune
	# Por exemplo, ativar uma runa, mudar o estado do jogo, etc.


func _on_button_button_pressed(index: Variant) -> void:
	pass # Replace with function body.
