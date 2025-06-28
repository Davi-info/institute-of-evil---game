extends CharacterBody2D
class_name Player

var _state_machine
var is_dead: bool = false
var _is_attacking: bool = false

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _friction: float = 0.2
@export var _acceleration: float = 0.2

@export_category("Objects")
@export var _attack_timer: Timer
@export var _animation_tree: AnimationTree

func _ready() -> void:
	_state_machine = _animation_tree.get("parameters/playback")

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	_move()
	_animate()
	move_and_slide()

func _move() -> void:
	var _direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if _direction != Vector2.ZERO:
		_animation_tree.set("parameters/idle/blend_position", _direction)
		_animation_tree.set("parameters/walk/blend_position", _direction)

		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)
	else:
		velocity = Vector2.ZERO

func _animate() -> void:
	if velocity.length() > 10:
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")

func die() -> void:
	is_dead = true
	_state_machine.travel("death")

	await get_tree().create_timer(1.0).timeout
	

	GameState.tentativas -= 1

	# Atualiza o HUD se estiver presente
	var hud := get_tree().current_scene.get_node_or_null("HUD")
	if hud and hud.has_method("atualizar_tentativas"):
		hud.atualizar_tentativas()

	if GameState.tentativas > 0:
		match GameState.fase_atual:
			"fase1":
				get_tree().change_scene_to_file("res://levels/level_1.tscn")
			"fase2":
				get_tree().change_scene_to_file("res://levels/level_2.tscn")
			"fase3":
				get_tree().change_scene_to_file("res://levels/level_3.tscn")
	else:
		get_tree().change_scene_to_file("res://interface/gameover.tscn")
