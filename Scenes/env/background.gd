extends ParallaxBackground

@onready var background_layer: TextureRect = get_node("ParallaxLayer/BackgroundLayer") # Instaciando TextureRect
@onready var parallax_layer: ParallaxLayer = get_node("ParallaxLayer")

# Array com todos as imagens de fundo disponíveis
var background_images_list: Array = [
	"res://assets/Background/Blue.png",
	"res://assets/Background/Brown.png",
	"res://assets/Background/Gray.png",
	"res://assets/Background/Green.png",
	"res://assets/Background/Pink.png",
	"res://assets/Background/Purple.png",
	"res://assets/Background/Yellow.png"
]

@export var direction: Vector2
@export var move_speed: float

# Função para carregar imagem aletória da lista de imagens de fundo
func _ready() -> void:
	background_layer.texture = load(
		background_images_list[
			# Função randi para escolher um número aleatório no alcance do tamanho da nossa array de imagens
			randi () % background_images_list.size() 
		]
	)

func _physics_process(delta: float) -> void:
	parallax_layer.motion_offset += direction * delta * move_speed
