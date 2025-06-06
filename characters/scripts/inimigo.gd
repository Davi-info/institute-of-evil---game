extends CharacterBody2D

@export var speed : float = 20.0
@export var intervalo_ataque: float = 2.0

var player: CharacterBody2D = null
var vida: int = 10 
var dano: int = 2
var pode_atacar = true

func _physics_process(delta: float) -> void:
	if player != null and player.is_inside_tree():
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide(velocity)
	else:
		velocity = Vector2.ZERO
		move_and_slide(velocity)

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
