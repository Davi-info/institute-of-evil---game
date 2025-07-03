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

@onready var attention_icon = get_node_or_null("AttentionIcon")
@onready var detection_area = get_node("DetectionArea")

@export var waypoints_path: NodePath = ^"Waypoints"
var _patrol_index = 0
var _patrol_points: Array[Vector2] = []
var _patr#const WANDER_INTERVAL := 2.0ol_index := 0
const POINT_THRESHOLD := 4.0   # distância para “chegou”

@export_category('Objects')
@export var _texture : Sprite2D = null
@export var _animation : AnimationPlayer = null
@export var _animation_tree: AnimationTree = null

const SPEED := 20.0

func _ready() -> void:
	if attention_icon:
		attention_icon.visible = false

	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	
	if _animation_tree == null:
		_animation_tree = $AnimationTree
	if _animation_tree == null:
		push_error("AnimationTree is not assigned and could not be found as a child.")
		return
	_state_machine = _animation_tree["parameters/playback"]
	# Carregar pontos de patrulha
	var wp_parent := get_node_or_null(waypoints_path)
	if wp_parent:
		for child in wp_parent.get_children():
			if child is Node2D:
				_patrol_points.append(child.global_position)
	if _patrol_points.is_empty():
		push_error("Nenhum waypoint encontrado! Adicione Position2D dentro de Waypoints.")
	
func _on_detection_area_body_entered(_body: Node2D) -> void:
	
	if _body.is_in_group('player'):
		if has_line_of_sight_to(_body) and not _body.is_hidden:
			_player_ref = _body
	
	if _body.is_in_group("player") and _body.has_node("AttentionIcon"):
		_body.get_node("AttentionIcon").visible = true
		
	if _body is Inimigo and attention_icon:
		attention_icon.visible = true
	
func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body.is_in_group('player'):
		_player_ref = null
	
	if _body.is_in_group("player") and _body.has_node("AttentionIcon"):
		_body.get_node("AttentionIcon").visible = false
			
	if _body is Inimigo and attention_icon:
		var bodies = detection_area.get_overlapping_bodies()
		var enemy_nearby = false
		for b in bodies:
			if b is Inimigo:
				enemy_nearby = true
				break
		if not enemy_nearby:
			attention_icon.visible = false
			
	if not ja_falou:
			fala_engracada()
			ja_falou = true
				
func has_line_of_sight_to(target: Node2D) -> bool:
	if target.has_method("is_hidden") and target.is_hidden:
		return false

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)

	return result.is_empty() or result.collider == target


func fala_engracada():
	print("Inimigo5 diz: Você não tem chance!")

	var som = get_node_or_null("FalaInimigo")
	if som:
		if som.stream != null:
			som.play()
		else:
			print("ERRO: Nenhum áudio configurado no Stream de FalaInimigo!")
	else:
		print("ERRO: Nó FalaInimigo não encontrado no inimigo!")

	
func _physics_process(delta: float) -> void:
	var move_dir = Vector2.ZERO

	match state:
		PATROLLING:
			if _patrol_points.is_empty():
				velocity = Vector2.ZERO
			else:
				var target := _patrol_points[_patrol_index]
				move_dir = global_position.direction_to(target)
				velocity = move_dir * (SPEED * 0.5)

				if global_position.distance_to(target) < POINT_THRESHOLD:
					_patrol_index = (_patrol_index + 1) % _patrol_points.size()

			if _player_ref and not _player_ref.is_dead and not _player_ref.is_hidden:
				state = CHASING

		CHASING:
			if _player_ref and not _player_ref.is_dead and not _player_ref.is_hidden:
				move_dir = global_position.direction_to(_player_ref.global_position)
				var distance = global_position.distance_to(_player_ref.global_position)

				if distance < 20:
					_player_ref.die()
					velocity = Vector2.ZERO
					move_and_slide()
					return

				velocity = move_dir * SPEED
			else:
				state = SEARCHING
				search_timer = SEARCH_DURATION

		SEARCHING:
			search_timer -= delta
			if search_timer <= 0:
				state = PATROLLING

		IDLE:
			velocity = Vector2.ZERO

	# Aplica movimento e animação com a direção final calculada
	move_and_slide()
	_animate(move_dir)


	match state:
		PATROLLING:
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
		velocity = move_dir * (SPEED * 0.5)

	move_and_slide()
	_animate(move_dir)

func _animate(move_dir: Vector2) -> void:
	if move_dir.length() > 0.1:
		var dir = move_dir.normalized()
		_animation_tree.set("parameters/Idle/blend_position", dir)
		_animation_tree.set("parameters/walk/blend_position", dir)
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")
