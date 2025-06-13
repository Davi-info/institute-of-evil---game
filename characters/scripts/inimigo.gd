extends CharacterBody2D
class_name Inimigo

var _player_ref = null
@export_category('Objects')
@export var _texture : Sprite2D = null
@export var _animation : AnimationPlayer = null

func _on_detection_area_body_entered(_body: Node2D) -> void:
	if _body.is_in_group('player'):
		_player_ref = _body
	
func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body.is_in_group('player'):
		_player_ref = null

func _physics_process(_delta: float) -> void:
	_animate()
	if _player_ref != null:
		if _player_ref.is_dead:
			velocity = Vector2.ZERO
			move_and_slide()
			return

		var _direction: Vector2 = global_position.direction_to(_player_ref.global_position)
		var _distance: float = global_position.distance_to(_player_ref.global_position)
		if _distance < 20:
			_player_ref.die()
			
		velocity = _direction * 30
		move_and_slide()
	
func _animate() -> void:
	_animation.play('idle')

#@export var speed: float = 20.0
#@export var intervalo_ataque: float = 2.0
#@export var dano: int = 2
#@export var vida: int = 10
#
#var player: CharacterBody2D = null
#var pode_atacar := true
#
#func _physics_process(delta: float) -> void:
	#if player and player.is_inside_tree():
		#var direction = (player.global_position - global_position).normalized()
		#velocity = direction * speed
	#else:
		#velocity = Vector2.ZERO
	#
	#move_and_slide()
#
#
#func _on_detection_area_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#player = body as CharacterBody2D
#
#func _on_detection_area_body_exited(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#player = null
		
