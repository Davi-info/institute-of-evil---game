extends Node

var tentativas: int = 5
var fase_atual: String = "fase1"
#var accs_coletadas: int = 0

func reset() -> void:
	tentativas = 5
#	accs_coletadas = 0
	fase_atual = "fase1"
