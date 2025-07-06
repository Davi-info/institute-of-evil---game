# SafeInputUI.gd
extends CanvasLayer

@onready var code_line_edit = $Panel/CodeLineEdit
@onready var confirm_button = $Panel/ConfirmButton

signal code_entered(code_text)

func _ready():
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	code_line_edit.grab_focus() # Garante que o campo de texto está focado

func _on_confirm_button_pressed():
	emit_signal("code_entered", code_line_edit.text)
	queue_free() # Remove a UI da cena após a entrada

func _unhandled_input(event):
	# Permite fechar a UI com Esc, por exemplo
	if event.is_action_pressed("ui_cancel"):
		queue_free()
