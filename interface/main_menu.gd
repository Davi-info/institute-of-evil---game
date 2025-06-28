extends Control

# Nó para o fade overlay
var fade_overlay: ColorRect

func _ready():
	# Cria o fade overlay
	create_fade_overlay()
	
	for button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(on_button_pressed.bind(button))
		button.mouse_exited.connect(mouse_interaction.bind(button, "exited"))
		button.mouse_entered.connect(mouse_interaction.bind(button, "entered"))

func create_fade_overlay():
	# Cria um overlay preto que cobrirá toda a tela
	fade_overlay = ColorRect.new()
	fade_overlay.name = "FadeOverlay"
	fade_overlay.color = Color.BLACK
	fade_overlay.modulate.a = 0.0  # Começa invisível
	
	# Configura para cobrir toda a tela
	fade_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_overlay.z_index = 100  # Garante que fica na frente de tudo
	
	# Adiciona como filho do nó atual
	add_child(fade_overlay)

func on_button_pressed(button: Button) -> void:
	match button.name:
		'Play':
			# Desabilita todos os botões imediatamente
			set_buttons_disabled(true)
			
			# Toca o som E inicia o fade simultaneamente
			$PlaySound.play()
			
			# Inicia o fade para preto IMEDIATAMENTE
			await start_fade_to_black()
			
			# Muda para o próximo nível
			MusicMenu.stop_music()
			get_tree().change_scene_to_file("res://levels/level_1.tscn")
			
		'Controls':
			get_tree().change_scene_to_file("res://interface/controls_view.tscn")
		'Exit':
			get_tree().quit()

func start_fade_to_black():
	# Usa Tween para fazer o fade suavemente
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# Anima o fade overlay de transparente (0.0) para opaco (1.0)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 2.5)  # 2.5 segundos de duração
	
	# Espera o tween terminar
	await tween.finished
	
	# Aguarda um pouco mais para garantir que a tela está completamente preta
	await get_tree().create_timer(0.2).timeout

func set_buttons_disabled(disabled: bool):
	# Desabilita/habilita todos os botões
	for button in get_tree().get_nodes_in_group("button"):
		button.disabled = disabled

func mouse_interaction(button: Button, state: String) -> void:
	# Só aplica o efeito se o botão não estiver desabilitado
	if button.disabled:
		return
		
	match state:
		'exited':
			button.modulate.a = 1.0
		'entered':
			button.modulate.a = 0.5
