extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	$AnimationPlayer.play("Diretor_preso")
