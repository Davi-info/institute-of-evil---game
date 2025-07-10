# interruptor.gd
extends StaticBody2D

# Sinal emitido quando o interruptor é ativado.
# Vamos conectar este sinal ao script principal da fase.
signal ativado

# Pre-carrega as texturas para os estados do interruptor.
# Arraste suas imagens do painel "Sistema de Arquivos" para estas variáveis no Inspetor.
@export var textura_desativado: Texture2D
@export var textura_ativado: Texture2D

# Variáveis para controlar o estado
var esta_ativado: bool = false
var player_na_area: bool = false

# Referência ao nó Sprite2D
@onready var sprite = $Sprite2D

func _ready():
	# Garante que o sprite inicial seja o desativado
	if textura_desativado:
		sprite.texture = textura_desativado
	else:
		print("Aviso: Textura 'desativado' não definida para o interruptor.")

# Função chamada quando o jogador pressiona uma tecla
func _input(event):
	# Verifica se o jogador está na área, se a tecla de interação foi pressionada
	# e se o interruptor ainda não foi ativado.
	if player_na_area and event.is_action_pressed("interact") and not esta_ativado:
		ativar_interruptor()

func ativar_interruptor():
	esta_ativado = true
	
	# Muda o sprite para o estado "ativado"
	if textura_ativado:
		sprite.texture = textura_ativado
	else:
		print("Aviso: Textura 'ativado' não definida para o interruptor.")
		
	# Emite o sinal para que a fase saiba que este interruptor foi ativado
	emit_signal("ativado")
	print("Interruptor ativado!")

# Detecta quando um corpo (como o jogador) entra na área
func _on_body_entered(body):
	# Verifica se o corpo que entrou pertence ao grupo "player"
	if body.is_in_group("player"):
		player_na_area = true
		print("Jogador entrou na área do interruptor.")

# Detecta quando o corpo sai da área
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_na_area = false
		print("Jogador saiu da área do interruptor.")
