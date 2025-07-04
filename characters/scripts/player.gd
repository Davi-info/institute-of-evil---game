extends CharacterBody2D
class_name Player

var _state_machine
var is_dead: bool = false
var _is_attacking: bool = false
var alert_sound_playing: bool = false
var is_hidden = false

var near_trash_bin: bool = false
var current_trash_bin: Node = null

@onready var attention_icon = get_node("AttentionIcon")
@onready var detection_area = get_node("DetectionArea")
@onready var alert_sound = get_node("AlertSound") 
@onready var texture: Sprite2D = $Texture


@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _friction: float = 0.2
@export var _acceleration: float = 0.2

@export_category("Objects")
@export var _attack_timer: Timer
@export var _animation_tree: AnimationTree


func _ready() -> void:
	if not alert_sound:
		alert_sound = AudioStreamPlayer2D.new()
		add_child(alert_sound)
		alert_sound.volume_db = -5.0  # Ajuste o volume conforme necessário
		
	_state_machine = _animation_tree.get("parameters/playback")
	attention_icon.visible = false
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)

func _on_detection_area_body_entered(body):
	if body is Inimigo:
		attention_icon.visible = true
		_play_alert_sound()

func _on_detection_area_body_exited(body):
	if body is Inimigo:
		var enemies_nearby = false
		for b in detection_area.get_overlapping_bodies():
			if b is Inimigo:
				enemies_nearby = true
				break
		if not enemies_nearby:
			attention_icon.visible = false
			_stop_alert_sound()

func _play_alert_sound():
	if not alert_sound_playing and alert_sound.stream:
		alert_sound.play()
		alert_sound_playing = true

func _stop_alert_sound():
	if alert_sound_playing:
		alert_sound.stop()
		alert_sound_playing = false

# NOVO: lidar com entrada e saída da área da lixeira
func _on_trash_bin_area_entered(area):
	near_trash_bin = true
	current_trash_bin = area.get_parent()

func _on_trash_bin_area_exited(area):
	near_trash_bin = false
	current_trash_bin = null

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	if near_trash_bin and Input.is_action_just_pressed("interact"):
		if not is_hidden:
			set_hidden(true)
		else:
			set_hidden(false)

	if not is_hidden:
		_move()
		_animate()
		move_and_slide()
	else:
		velocity = Vector2.ZERO
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

func set_hidden(value: bool):
	is_hidden = value
	visible = not value  # Esconde ou mostra o player inteiro

	if value:
		attention_icon.visible = false
		_stop_alert_sound()
