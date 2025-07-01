extends CharacterBody2D
class_name Inimigo

enum {
	PATROLLING,
	CHASING,
	SEARCHING,
	IDLE
}
var state = PATROLLING
var search_timer := 0.0
const SEARCH_DURATION := 3.0
var ja_falou: bool = false
var _state_machine
var _player_ref = null
var _wander_direction := Vector2.ZERO
var _wander_timer := 0.0

@export_category('Objects')
@export var _texture : Sprite2D = null
@export var _animation : AnimationPlayer = null
@export var _animation_tree: AnimationTree = null

const SPEED := 30.0
const WANDER_INTERVAL := 2.0

func _ready() -> void:
	if _animation_tree == null:
		_animation_tree = $AnimationTree
	if _animation_tree == null:
		push_error("AnimationTree is not assigned and could not be found as a child.")
		return
	_state_machine = _animation_tree["parameters/playback"]

func _on_detection_area_body_entered(_body: Node2D) -> void:
	if _body.is_in_group('player'):
		if has_line_of_sight_to(_body):
			_player_ref = _body

func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body.is_in_group('player'):
		_player_ref = null
	if not ja_falou:
			fala_engracada()
			ja_falou = true
			
func has_line_of_sight_to(target: Node2D) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)

	return result.is_empty() or result.collider == target


func fala_engracada():
	print("Inimigo diz: Você não tem chance!")

	var som = get_node_or_null("FalaInimigo")
	if som:
		if som.stream != null:
			som.play()
		else:
			print("ERRO: Nenhum arquivo de áudio configurado no Stream de FalaInimigo!")
	else:
		print("ERRO: Nó FalaInimigo não encontrado no inimigo!")

	
func _physics_process(delta: float) -> void:
	var move_dir = Vector2.ZERO

	match state:
		PATROLLING:
			_wander_timer -= delta
			if _wander_timer <= 0.0:
				_wander_timer = WANDER_INTERVAL
				_wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

			move_dir = _wander_direction
			velocity = move_dir * (SPEED * 0.5)

			if _player_ref and not _player_ref.is_dead:
				state = CHASING

		CHASING:
			if _player_ref and not _player_ref.is_dead:
				var to_player = global_position.direction_to(_player_ref.global_position)
				var distance = global_position.distance_to(_player_ref.global_position)

				if distance < 20:
					_player_ref.die()
					velocity = Vector2.ZERO
					move_and_slide()
					return

				move_dir = to_player
				velocity = move_dir * SPEED
			else:
				state = SEARCHING
				search_timer = SEARCH_DURATION

		SEARCHING:
			search_timer -= delta
			if search_timer <= 0:
				state = PATROLLING

	move_and_slide()
	_animate(move_dir)

	if _player_ref != null and not _player_ref.is_dead:
		var to_player = global_position.direction_to(_player_ref.global_position)
		var distance = global_position.distance_to(_player_ref.global_position)

		if distance < 20:
			_player_ref.die()
			velocity = Vector2.ZERO
			move_and_slide()
			return

		move_dir = to_player
		velocity = move_dir * SPEED
	else:
		# Wander randomly
		_wander_timer -= delta
		if _wander_timer <= 0.0:
			_wander_timer = WANDER_INTERVAL
			_wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

		move_dir = _wander_direction
		velocity = move_dir * (SPEED * 0.5)

	move_and_slide()
	_animate(move_dir)

func _animate(move_dir: Vector2) -> void:
	if move_dir.length() > 0.1:
		_animation_tree.set("parameters/Idle/blend_position", move_dir)
		_animation_tree.set("parameters/walk/blend_position", move_dir)
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")
