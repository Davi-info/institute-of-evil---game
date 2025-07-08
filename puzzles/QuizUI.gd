# QuizUI.gd
extends CanvasLayer

@onready var question_label = $Panel/QuestionLabel
@onready var option_a_button = $Panel/OptionsContainer/OptionAButton
@onready var option_b_button = $Panel/OptionsContainer/OptionBButton
@onready var option_c_button = $Panel/OptionsContainer/OptionCButton

signal quiz_answered(is_correct)

func _ready():
	option_a_button.pressed.connect(func(): _on_option_selected(option_a_button.text))
	option_b_button.pressed.connect(func(): _on_option_selected(option_b_button.text))
	option_c_button.pressed.connect(func(): _on_option_selected(option_c_button.text))

func _on_option_selected(selected_text: String):
	var correct_answer = "0101" # A resposta correta para "Qual é o valor binário do número 5?"
	var is_correct = (selected_text == correct_answer)
	
	print("Resposta selecionada: ", selected_text, ". Correta: ", is_correct)
	emit_signal("quiz_answered", is_correct)
	queue_free() # Remove a UI da cena após a resposta

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		queue_free() # Permite fechar o quiz com Esc
