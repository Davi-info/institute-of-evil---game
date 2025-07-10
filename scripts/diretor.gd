# diretor.gd
extends CharacterBody2D

# --- SEU CÓDIGO ORIGINAL (MANTIDO) ---
# Referências aos AudioStreamPlayer
var audio_fala1
var audio_fala2
var timer_fala

# Controle de estado
var interagiu: bool = false
var player_proximo: bool = false
var player_reference = null

# --- NOVA VARIÁVEL (ADICIONADA) ---
# Novo estado para controlar se o diretor foi libertado pelo puzzle
var foi_libertado: bool = false

# --- SEU CÓDIGO ORIGINAL (MANTIDO) ---
# Distância para detectar o player
var distancia_interacao: float = 100.0

func _ready():
	$AnimationPlayer.play("imprisoned_director")
	
	# Busca os nós manualmente
	audio_fala1 = get_node("Audiofala1")
	audio_fala2 = get_node("Audiofala2") 
	timer_fala = get_node("Timerfala")
	
	# Verifica se todos os nós foram encontrados
	if audio_fala1 == null:
		print("Erro: Nó 'Audiofala1' não encontrado!")
		return
	if audio_fala2 == null:
		print("Erro: Nó 'Audiofala2' não encontrado!")
		return
	if timer_fala == null:
		print("Erro: Nó 'Timerfala' não encontrado!")
		return
	
	# Configura o timer para 5 segundos
	timer_fala.wait_time = 5.0
	timer_fala.timeout.connect(_on_timer_timeout)
	
	# Inicia o timer automaticamente
	timer_fala.start()
	
	print("Diretor iniciado com sucesso!")

func _process(_delta):
	# Verifica se o player está próximo (substitui a Area2D)
	_verificar_proximidade_player()

func _verificar_proximidade_player():
	# Procura por um nó com o nome "Player" na cena
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		else:
			player = get_tree().current_scene.find_child("Player", true, false)
	
	if player != null:
		var distancia = global_position.distance_to(player.global_position)
		
		if distancia <= distancia_interacao and not player_proximo:
			player_proximo = true
			player_reference = player
			_mostrar_indicacao_interacao(true)
		elif distancia > distancia_interacao and player_proximo:
			player_proximo = false
			player_reference = null
			_mostrar_indicacao_interacao(false)

# --- FUNÇÃO _input (MODIFICADA) ---
# A lógica foi expandida para lidar com o estado 'foi_libertado'.
func _input(event):
	# Verifica se o player está próximo e pressionou a tecla de interação
	if event.is_action_pressed("ui_accept") and player_proximo:
		if foi_libertado:
			# Se o diretor já foi libertado, a interação conclui o jogo.
			_concluir_jogo()
		elif not interagiu:
			# Caso contrário, executa a interação normal de "fala".
			_interagir_com_diretor()

func _on_timer_timeout():
	# Reproduz a fala apropriada baseada no estado
	# --- MODIFICAÇÃO: Não tocar áudio de socorro se já foi libertado ---
	if not interagiu and not foi_libertado:
		_reproduzir_fala1()
	elif interagiu and player_proximo:
		_reproduzir_fala2()

# --- SEU CÓDIGO ORIGINAL (MANTIDO) ---
func _reproduzir_fala1():
	if audio_fala1 == null or audio_fala2 == null: return
	audio_fala2.stop()
	audio_fala1.play()
	print("Diretor: Socorro! Alguém me ajude!")

func _reproduzir_fala2():
	if audio_fala1 == null or audio_fala2 == null: return
	audio_fala1.stop()
	audio_fala2.play()
	print("Diretor: Obrigado! Agora posso falar normalmente!")

func _interagir_com_diretor():
	if audio_fala1 == null: return
	interagiu = true
	audio_fala1.stop()
	_reproduzir_fala2()
	print("Player interagiu com o diretor!")

# --- FUNÇÃO _mostrar_indicacao_interacao (MODIFICADA) ---
# A mensagem de interação agora muda dependendo do estado do diretor.
func _mostrar_indicacao_interacao(mostrar: bool):
	if mostrar:
		if foi_libertado:
			print("Pressione ENTER para concluir a fase.")
		elif not interagiu:
			print("Pressione ENTER para interagir com o diretor")

# --- SEU CÓDIGO ORIGINAL (MANTIDO) ---
func ja_interagiu() -> bool:
	return interagiu

func forcar_interacao():
	if not interagiu:
		_interagir_com_diretor()

# --- FUNÇÃO reiniciar_estado (MODIFICADA) ---
# Adicionamos o reset da nova variável 'foi_libertado'.
func reiniciar_estado():
	interagiu = false
	player_proximo = false
	player_reference = null
	foi_libertado = false # Resetar o estado de liberdade
	$AnimationPlayer.play("imprisoned_director") # Garantir que a animação volte ao normal
	if timer_fala != null:
		timer_fala.start()
	if audio_fala1 != null:
		audio_fala1.stop()
	if audio_fala2 != null:
		audio_fala2.stop()

func definir_distancia_interacao(nova_distancia: float):
	distancia_interacao = nova_distancia

# --- NOVAS FUNÇÕES (ADICIONADAS) ---

# Esta função será chamada pelo script da fase (level_3.gd)
# quando todos os interruptores forem ativados.
func libertar():
	if not foi_libertado:
		print("O diretor foi libertado!")
		foi_libertado = true
		
		# Muda a animação para o estado livre
		$AnimationPlayer.play("free_director")
		
		# Para os áudios de socorro
		if timer_fala != null and not timer_fala.is_stopped():
			timer_fala.stop()
		if audio_fala1 != null:
			audio_fala1.stop()

# Função para finalizar o nível
func _concluir_jogo():
	print("Parabéns! Você salvou o diretor e concluiu a fase!")
	# Adicione aqui a lógica para mudar de cena, por exemplo:
	# get_tree().change_scene_to_file("res://cenas/vitoria.tscn")
	# ou
	# get_tree().change_scene_to_file("res://cenas/menu_principal.tscn")
