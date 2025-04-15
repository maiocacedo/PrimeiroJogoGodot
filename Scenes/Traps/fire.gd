extends StaticBody2D

# Instanciando propriedades
@onready var state_timer: Timer = get_node("StateTimer")
@onready var animation: AnimationPlayer = get_node("Animation")

var max_health: int = 0
var current_state: String = "off" # String que representa o estado atual
var is_invincible: bool = false

@export var damage: int
@export var health: int = 15

func _ready() -> void:
	max_health = health

# Função para ativação da armadilha, alternando entre on e off
func on_state_timer_timeout() -> void:
	state_timer.start()
	
	# se estado atual for off, torná-lo on e invencivel
	if current_state == "off":
		current_state = "on"
		is_invincible = true
		animation.play(current_state)
		return
	
	# se estado atual for on, torná-lo off
	if current_state == "on":
		current_state = "off"
		is_invincible = false
		animation.play(current_state)
		return


# Detectar se inimigo entrou na area 
func on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"):
		body.update_health(global_position, damage, "decrease")

# Função para atualizar a vida da armadilha
func update_health(value: int) -> void:
	# verifica se armadilha está invencivel 
	if is_invincible:
		return
	
	# Decrementa a vida, com limite de 0 a max_health
	health = clamp(health - value,0, max_health)
	# Se a vida da Armadilha for igual a zero, ela para de mudar de estado
	if health == 0:
		state_timer.stop()
		current_state = "off"
		animation.play(current_state)
		return
	animation.play("hit")

# Verifica a animação que está sendo finalizada
func on_animation_animation_finished(anim_name: StringName) -> void:
	# Se for hit, executar currente_state
	if anim_name  == "hit": 
		animation.play(current_state)
	pass # Replace with function body.
