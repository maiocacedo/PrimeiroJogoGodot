extends Area2D

@onready var sprite: Sprite2D = get_node("Texture")

# Lista de frutas
var fruits_list: Array=[
	"res://Assets/Items/Fruits/Apple.png",
	"res://Assets/Items/Fruits/Bananas.png",
	"res://Assets/Items/Fruits/Cherries.png",
	"res://Assets/Items/Fruits/Kiwi.png",
	"res://Assets/Items/Fruits/Melon.png",
	"res://Assets/Items/Fruits/Orange.png",
	"res://Assets/Items/Fruits/Pineapple.png",
	"res://Assets/Items/Fruits/Strawberry.png"
]

# Lista de pontuação das frutas
var scores_list: Array = [
	10, # maça
	100, # banana
	30, # cereja
	80, # kiwi
	50, # melao
	40, # laranja
	90, # abacaxi
	20 # morango 
]
var score: int = 0

@export var collected_effect: PackedScene = null

# Função ready
func _ready() -> void:
	randomize() 
	var random_number: int = randi() % fruits_list.size() # gera numero aleatório para o indice da fruta
	
	sprite.texture = load(
		fruits_list[random_number] # carrega fruta aleatória
	)
	
	score = scores_list[random_number] # pontuação de acordo com a fruta coletada

# checa se o corpo na area de colisão da fruta é do player
func on_body_entered(body: Node2D) -> void:
	# Se for o player
	if body.is_in_group("mask_dude"):
		body.update_score(score) # player pontua
		spawn_effect()
		queue_free() # Limpando fila randomizer
	pass # Replace with function body.

# Função para posicionar o objeto
func spawn_effect() -> void:
	var effect = collected_effect.instantiate() # instancia o efeito
	effect.global_position = global_position # recebe a posição da fruta
	get_tree().root.call_deferred("add_child", effect) 
