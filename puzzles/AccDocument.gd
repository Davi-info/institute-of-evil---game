extends Area2D

@export var document_id: String = "acc1" # Identificador único para o documento (ex: "acc1", "acc2", "acc3")

var can_interact = false
var collected = false

func _ready():
	# Conecta o sinal body_entered para detectar quando o jogador entra na área
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player": # Verifique se o corpo que entrou é o jogador
		can_interact = true
		print("Jogador entrou na área do documento %s. Pressione 'E' para coletar." % document_id)
		# Opcional: Mostrar um prompt de UI para o jogador

func _on_body_exited(body):
	if body.name == "Player":
		can_interact = false
		print("Jogador saiu da área do documento %s." % document_id)
		# Opcional: Esconder o prompt de UI

func _process(delta):
	if can_interact and Input.is_action_just_pressed("interact") and not collected:
		collect_document()

func collect_document():
	if not collected:
		collected = true
		GameManager.collect_acc() # Chama a função no GameManager
		print("Documento %s coletado!" % document_id)
		queue_free() # Remove o documento da cena após ser coletado
