extends CharacterBody2D

@onready var sprite: Sprite2D = get_node("Texture") # Instanciando o nó de Sprites
@onready var stomp_area_collison: CollisionShape2D = get_node("StompArea/Collison")


var total_score: int = 0
var jump_count: int = 0 # contador de pulo 
var is_on_double_jump: bool = false # check para pulo duplo
var knockback_direction: Vector2 
var on_knockback: bool = false
var max_health: float = 0.0
var is_dead: bool = false

# EXPORTANDO PROPRIEDADES
@export var health: float = 25.0
@export var move_speed: float = 32.0 
@export var jump_speed: float = -256.0
@export var gravity_speed: float = 512.0
@export var damage: int = 5

func _ready() -> void:
	max_health = health
	

# Função para executar os movimentos do personagem e sua animação
func _physics_process(delta: float) -> void:
	# Verifica se o personagem está morto
	if is_dead:
		return
	# Verifica se o personagem está em knockback
	if on_knockback:
		knockback_move()
		return
		
	move() # Permite movimento
	velocity.y += delta * gravity_speed # aplica gravidade
	var _move := move_and_slide()
	jump() # Permite pulo
	
	sprite.animate(velocity) # anima o movimento

func knockback_move() -> void:
	velocity = knockback_direction * move_speed * 2
	var _move := move_and_slide()
	sprite.animate(velocity)

# Função para caminhar
func move() -> void:
	var direction: float = get_direction()
	velocity.x = direction * move_speed
	

# Função para receber a direção do personagem
func get_direction() -> float:
	return(
		Input.get_axis("walk_left", "walk_right")
	)

# Função de pulo
func jump():
	# Checando se o personagem esta no chão
	if is_on_floor():
		jump_count = 0 # resetando contador
		is_on_double_jump = false # resetando check de pulo duplo
		stomp_area_collison.set_deferred("disabled", true) # desativa colisão
	
	# checando se o personagem está pulando
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		stomp_area_collison.set_deferred("disabled", false) # ativa colisão
		velocity.y = jump_speed 
		jump_count += 1 # incremento no contador de pulo
	
	# Checando se o personagem está em pulo duplo
	if  jump_count == 2 and not is_on_double_jump:
		sprite.action_behavior("double_jump")
		is_on_double_jump = true
# função para atualizar a vida
func update_health(target_position: Vector2, value:int, type:String) -> void:
	if is_dead:
		return
	# Verifica se é dano
	if type == "decrease":
		# Atualiza o direção do knockback
		knockback_direction = (global_position - target_position).normalized()
		# chama a ação de hit, junto com a animação
		sprite.action_behavior("hit")
		on_knockback = true
		# subtrair valor da vida, sem passar dos limites 0 e vida máxima
		health = clamp(health - value, 0, max_health)
		TransitionScreen.current_health = health
		get_tree().call_group("interface", "update_health", health)
		
		if health == 0:
			is_dead = true
			TransitionScreen.reset()
			sprite.action_behavior("dead")
		
		return
	# Verifica se é cura
	if type == "increase":
		# adiciona valor na vida, sem passar dos limites 0 e vida máxima
		health = clamp(health + value, 0, max_health)
		TransitionScreen.current_health = health
		get_tree().call_group("interface", "update_health", health)
		
		
# Função para verificar se o personagem está "caindo" na armadilha para dano
func on_stomp_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("hazards"):
		body.update_health(damage)
		# Atualiza o direção do knockback
		knockback_direction = (global_position - body.global_position).normalized()
		# chama a ação de hit, junto com a animação
		sprite.action_behavior("hit")
		on_knockback = true
	pass # Replace with function body.


func update_score(score: int) -> void:
	total_score += score
	TransitionScreen.current_score = total_score
	get_tree().call_group("interface", "update_score", total_score)
	print("Pontuação total: " + str(total_score)) 
	
