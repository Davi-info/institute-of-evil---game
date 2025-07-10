# level_3.gd
extends Node2D

# --- INÍCIO: Variáveis do Puzzle (adicionadas) ---
# Referência à cena do diretor. Lembre-se de arrastar o nó do Diretor
# do painel "Cena" para esta variável no Inspetor.
@export var diretor: CharacterBody2D

# Contadores para o puzzle
var total_interruptores: int = 0 # Iniciamos com 0 e atualizamos no _ready()
var interruptores_ativados: int = 0
# --- FIM: Variáveis do Puzzle ---


func _ready() -> void:
	# --- INÍCIO: Seu código original (mantido) ---
	MusicMenu.stop_music()
	GameState.fase_atual = "fase3"
	Dialogic.start("player_fim")
	# --- FIM: Seu código original ---

	# --- INÍCIO: Lógica do Puzzle (adicionada dentro do _ready) ---
	# Adicione seus 3 interruptores ao grupo "interruptores" no editor do Godot.
	# Este código vai procurar por eles e conectar seus sinais.
	var interruptores = get_tree().get_nodes_in_group("interruptores")
	for interruptor in interruptores:
		# Conecta o sinal 'ativado' de cada um à função '_on_interruptor_ativado'
		# O método 'callable' é a forma recomendada no Godot 4 para conexões.
		interruptor.ativado.connect(self._on_interruptor_ativado)
		
	total_interruptores = interruptores.size()
	
	if total_interruptores == 0:
		print("AVISO: Nenhum interruptor encontrado no grupo 'interruptores'. O puzzle não funcionará.")
	else:
		print("Fase iniciada. Total de interruptores para ativar: ", total_interruptores)
	# --- FIM: Lógica do Puzzle ---


# --- INÍCIO: Novas funções do Puzzle (adicionadas) ---

# Esta função será chamada toda vez que um interruptor emitir o sinal 'ativado'.
func _on_interruptor_ativado():
	interruptores_ativados += 1
	print("Interruptores ativados: ", interruptores_ativados, "/", total_interruptores)
	
	# Verifica se todos os interruptores foram ativados
	if interruptores_ativados >= total_interruptores and total_interruptores > 0:
		libertar_diretor()

func libertar_diretor():
	print("Todos os interruptores ativados! Libertando o diretor.")
	
	# Verifica se a referência ao diretor é válida
	if is_instance_valid(diretor):
		# Se você atualizou o script do diretor com a função 'libertar()',
		# chame-a aqui. É a melhor abordagem.
		if diretor.has_method("libertar"):
			diretor.libertar()
		else:
			# Caso contrário, controle a animação diretamente (plano B).
			print("Aviso: O script do diretor não tem o método 'libertar()'. Controlando a animação diretamente.")
			if diretor.has_node("AnimationPlayer"):
				diretor.get_node("AnimationPlayer").play("free_director")
	else:
		print("Erro: A referência ao nó do diretor é inválida. Verifique se ela foi atribuída no Inspetor.")

# --- FIM: Novas funções do Puzzle ---
