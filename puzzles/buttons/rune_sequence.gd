extends Node2D
 
@export var door : Sprite2D
@export var runes_order : Array[int]
 
var stack = []
 
func push_rune(value):
	stack.push_back(value)
	if stack.size() > 4:
		stack.pop_front()
	print(stack)
 
	if door == null:
		return
 
	if stack == runes_order:
		door.open_door()
		print("Door opened somewhere...")
	else:
		door.close_door()
		
func _on_Button_button_pressed(index_do_botao):
	print("Botão com índice ", index_do_botao, " foi pressionado!")
	# Aqui você colocaria a lógica que antes estava em push_rune
	# Por exemplo, ativar uma runa, mudar o estado do jogo, etc.


func _on_button_button_pressed(index: Variant) -> void:
	pass # Replace with function body.


func _on_button_2_button_pressed(index: Variant) -> void:
	pass # Replace with function body.


func _on_button_3_button_pressed(index: Variant) -> void:
	pass # Replace with function body.


func _on_button_4_button_pressed(index: Variant) -> void:
	pass # Replace with function body.
