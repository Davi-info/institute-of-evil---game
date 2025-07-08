# AccDocument.gd
extends Area2D

@export var document_id: String = "acc1"

var can_interact = false
var collected = false

func _ready():
	# Desabilita o monitoramento no início
	monitorable = false # Não detecta corpos
	monitoring = false  # Não emite sinais

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		can_interact = true
		print("Jogador entrou na área do documento %s. Pressione 'E' para coletar." % document_id)

func _on_body_exited(body):
	if body.name == "Player":
		can_interact = false
		print("Jogador saiu da área do documento %s." % document_id)

func _process(delta):
	if can_interact and Input.is_action_just_pressed("interact") and not collected:
		collect_document()

func collect_document():
	if not collected:
		collected = true
		GameManager.collect_acc()
		print("Documento %s coletado!" % document_id)
		queue_free()

# Nova função para habilitar o ACC quando liberado pelo puzzle
func enable_acc():
	monitorable = true
	monitoring = true
	print("ACC %s habilitado para coleta." % document_id)
