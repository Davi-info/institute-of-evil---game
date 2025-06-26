extends Area2D

func _ready():
	pass
	
func _process(delta: float):
	pass

func _on_body_entered(body: Node2D):
	queue_free()
	
