# PushableBookshelf.gd
extends CharacterBody2D
class_name PushableBookshelf

@onready var bookshelf_sprite = $Sprite2D

@export var push_duration: float = 0.6 # Aumentado para um movimento mais lento e suave
@export var push_distance_tiles: float = 0.5 # Reduzido para meio tile (32 pixels)
@export var push_direction: Vector2 = Vector2.UP

var original_position: Vector2
var is_pushed = false
var is_moving = false

func _ready():
	original_position = global_position
	print("PushableBookshelf: Posição inicial: ", original_position)

func apply_push(push_vector: Vector2):
	if not is_pushed and not is_moving:
		start_push_animation()

func start_push_animation():
	is_moving = true

	# Opcional: Pequeno atraso antes de começar a mover (para dar a sensação de "preparação")
	# await get_tree().create_timer(0.1).timeout # Descomente se quiser um atraso

	var tile_size = 64.0
	var target_position = original_position + (push_direction.normalized() * push_distance_tiles * tile_size)

	print("PushableBookshelf: Iniciando movimento discreto.")
	print("PushableBookshelf: Posição alvo: ", target_position)

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_property(self, "global_position", target_position, push_duration)

	await tween.finished

	is_pushed = true
	is_moving = false

	velocity = Vector2.ZERO
	set_physics_process(false)

	print("PushableBookshelf: Estante moveu %.1f tile(s) e parou." % push_distance_tiles)
	release_acc2()

func release_acc2():
	print("PushableBookshelf: Chamando release_acc2()...")
	var acc2_node = get_tree().current_scene.get_node_or_null("acc2")
	if acc2_node:
		print("PushableBookshelf: Nó 'acc2' encontrado!")
		acc2_node.visible = true
		acc2_node.enable_acc()
		print("ACC2 liberado da estante!")
	else:
		print("PushableBookshelf: ERRO: Nó 'acc2' NÃO encontrado na cena para ser liberado.")
