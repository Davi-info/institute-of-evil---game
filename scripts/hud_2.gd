extends CanvasLayer

@onready var mensagem_label = $MensagemLabel

func _ready():
	print("=== HUD SCRIPT CARREGADO ===")
	print("HUD nome: ", name)
	if mensagem_label:
		mensagem_label.visible = false
		print("MensagemLabel encontrado e configurado")
	else:
		print("ERRO: MensagemLabel não encontrado")

func mostrar_mensagem(texto):
	print("=== FUNÇÃO MOSTRAR_MENSAGEM CHAMADA ===")
	print("Texto: ", texto)
	if mensagem_label:
		mensagem_label.text = texto
		mensagem_label.visible = true
		print("Mensagem exibida na tela!")
		await get_tree().create_timer(3.0).timeout
		mensagem_label.visible = false
		print("Mensagem ocultada")
	else:
		print("ERRO: MensagemLabel não encontrado")
