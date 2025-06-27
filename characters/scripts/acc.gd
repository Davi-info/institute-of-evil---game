extends Area2D

func _on_body_entered(body: Node2D) -> void:
	#if body is Player:
	#	GameState.accs_coletadas += 1

		#var hud := get_tree().current_scene.get_node_or_null("HUD")
		#if hud and hud.has_method("atualizar_accs"):
			#hud.atualizar_accs()

		queue_free()
