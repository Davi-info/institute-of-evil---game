extends Control

@onready var controles_dialog = $ControlesDialog
@onready var creditos_dialog = $CreditosDialog

func _ready():
	# Conecta os botões
	$VBoxContainer/Button.text = "Jogar"
	$VBoxContainer/Button.pressed.connect(_on_jogar_pressed)

	$VBoxContainer/Button2.text = "Controles"
	$VBoxContainer/Button2.pressed.connect(_on_controles_pressed)

	$VBoxContainer/Button3.text = "Créditos"
	$VBoxContainer/Button3.pressed.connect(_on_creditos_pressed)

func _on_jogar_pressed():
	# Troca para a cena do jogo
	get_tree().change_scene_to_file("res://CenaDoJogo.tscn")

func _on_controles_pressed():
	controles_dialog.popup_centered()

func _on_creditos_pressed():
	creditos_dialog.popup_centered()
