extends CanvasLayer
@onready var mensagem_label = $MensagemLabel

func _ready():
	print("Script do HUD carregado corretamente!")
	print("Tipo do HUD: ", get_class())
	if mensagem_label:
		mensagem_label.visible = false
		print("MensagemLabel encontrado e ocultado")
	else:
		print("ERRO: MensagemLabel não encontrado!")
		print("Filhos do HUD:")
		for child in get_children():
			print("  - ", child.name, " (", child.get_class(), ")")

func mostrar_mensagem(texto: String):
	print("Função mostrar_mensagem chamada com: ", texto)
	if mensagem_label:
		mensagem_label.text = texto
		mensagem_label.visible = true
		print("Mensagem exibida na tela")
		
		# Aguardar 3 segundos e ocultar
		await get_tree().create_timer(3.0).timeout
		mensagem_label.visible = false
		print("Mensagem ocultada")
	else:
		print("ERRO: MensagemLabel não encontrado!")
