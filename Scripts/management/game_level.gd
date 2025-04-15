extends Node2D

@onready var player: CharacterBody2D = get_node("maninho_mascarado")
@onready var interface: CanvasLayer = get_node("Interface")

@export var scene_path: String = ""

# Função ready
func _ready() -> void:
	interface.update_health(player.max_health)
	
	# Recebendo caminho da cena
	TransitionScreen.target_path = scene_path
	
	# Se houver o sinal, executar start_level
	TransitionScreen.connect(
		"start_level", Callable(self, "start_level")
	)
	
	if TransitionScreen.current_score != 0:
		player.total_score = TransitionScreen.current_score
		interface.update_score(TransitionScreen.current_score)
	
	if TransitionScreen.current_health != 0:
		player.health = TransitionScreen.current_health
		interface.update_health(TransitionScreen.current_health)

# Função para iniciar Level
func start_level() -> void:
	print("sarve")
