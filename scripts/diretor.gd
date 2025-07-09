extends CharacterBody2D

# Referências aos AudioStreamPlayer
var audio_fala1
var audio_fala2
var timer_fala

# Controle de estado
var interagiu: bool = false
var player_proximo: bool = false
var player_reference = null

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
		print("Nós filhos disponíveis: ", get_children())
		return
	if audio_fala2 == null:
		print("Erro: Nó 'Audiofala2' não encontrado!")
		print("Nós filhos disponíveis: ", get_children())
		return
	if timer_fala == null:
		print("Erro: Nó 'Timerfala' não encontrado!")
		print("Nós filhos disponíveis: ", get_children())
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
		# Se não encontrar no grupo, tenta encontrar por nome
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		else:
			# Última tentativa: procura por nome
			player = get_tree().current_scene.find_child("Player", true, false)
	
	if player != null:
		var distancia = global_position.distance_to(player.global_position)
		
		if distancia <= distancia_interacao and not player_proximo:
			# Player entrou na área
			player_proximo = true
			player_reference = player
			_mostrar_indicacao_interacao(true)
		elif distancia > distancia_interacao and player_proximo:
			# Player saiu da área
			player_proximo = false
			player_reference = null
			_mostrar_indicacao_interacao(false)

func _input(event):
	# Verifica se o player está próximo e pressionou a tecla de interação
	if event.is_action_pressed("ui_accept") and player_proximo and not interagiu:
		_interagir_com_diretor()

func _on_timer_timeout():
	# Reproduz a fala apropriada baseada no estado
	if not interagiu:
		_reproduzir_fala1()
	else:
		# MUDANÇA: só reproduz fala2 se o player estiver próximo
		if player_proximo:
			_reproduzir_fala2()

func _reproduzir_fala1():
	# Verifica se o áudio existe antes de usar
	if audio_fala1 == null or audio_fala2 == null:
		print("Erro: Nós de áudio não encontrados!")
		return
	
	# Para qualquer som que esteja tocando e reproduz a fala 1
	audio_fala2.stop()
	audio_fala1.play()
	
	print("Diretor: Socorro! Alguém me ajude!")

func _reproduzir_fala2():
	# Verifica se o áudio existe antes de usar
	if audio_fala1 == null or audio_fala2 == null:
		print("Erro: Nós de áudio não encontrados!")
		return
	
	# Para qualquer som que esteja tocando e reproduz a fala 2
	audio_fala1.stop()
	audio_fala2.play()
	
	print("Diretor: Obrigado! Agora posso falar normalmente!")

func _interagir_com_diretor():
	# Verifica se o áudio existe antes de usar
	if audio_fala1 == null:
		print("Erro: audio_fala1 não encontrado!")
		return
	
	# Marca que houve interação
	interagiu = true
	
	# Para a fala 1
	audio_fala1.stop()
	
	# Reproduz imediatamente a fala 2
	_reproduzir_fala2()
	
	print("Player interagiu com o diretor!")

func _mostrar_indicacao_interacao(mostrar: bool):
	# Função para mostrar/esconder indicação visual de interação
	if mostrar and not interagiu:
		print("Pressione ENTER para interagir com o diretor")

# Função pública para verificar se já houve interação
func ja_interagiu() -> bool:
	return interagiu

# Função para forçar a interação (caso precise para outras partes do jogo)
func forcar_interacao():
	if not interagiu:
		_interagir_com_diretor()

# Função para reiniciar o estado (útil para debugging ou reiniciar level)
func reiniciar_estado():
	interagiu = false
	player_proximo = false
	player_reference = null
	if timer_fala != null:
		timer_fala.start()
	if audio_fala1 != null:
		audio_fala1.stop()
	if audio_fala2 != null:
		audio_fala2.stop()

# Função para alterar a distância de interação
func definir_distancia_interacao(nova_distancia: float):
	distancia_interacao = nova_distancia
