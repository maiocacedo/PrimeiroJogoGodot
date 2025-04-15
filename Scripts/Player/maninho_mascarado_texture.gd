extends Sprite2D

var on_action: bool = false

@export var dust_particles: GPUParticles2D
@export var animation: AnimationPlayer = null
@export var mask_dude: CharacterBody2D = null

# Função para animar o personagem
func animate(velocity: Vector2) -> void:
	
	change_orientation_based_on_direction(velocity.x)
	
	if on_action:
		dust_particles.emitting = false
		return
	
	if velocity.y != 0:
		dust_particles.emitting = false
		vertical_move_behavior(velocity.y)
		return
	
	horizontal_move_behavior(velocity.x)

# Função para alternar, rotacionar horizontalmente, o personagem de acordo com sua direção
func change_orientation_based_on_direction(direction: float) -> void:
	if direction > 0:
		flip_h = false
		
	if direction < 0:
		flip_h = true

# Função para definir animções de ações sem loop
func action_behavior(action: String) -> void:
	animation.play(action)
	on_action = true

# Função para movimentação vertical, como pulo, queda 
func vertical_move_behavior(direction: float) -> void:
	# se o persoagem está caindo
	if direction > 0:
		animation.play("fall")
	# se o personagem está subindo
	if direction < 0:
		animation.play("jump")
		
# Função para movimentação horizontal
func horizontal_move_behavior(direction: float) -> void:
	if direction != 0:
		animation.play("run")
		dust_particles.emitting =true
		return
		
	animation.play("idle")
	dust_particles.emitting = false

# Função para verificar se a animação foi finalizada
func on_animation_animation_finished(anim_name: StringName) -> void:
	on_action = false
	
	# se a animação for de hit, reseta knockback
	if anim_name == "hit":
		mask_dude.on_knockback = false
	
	# se animação for de morte, reseta a cena
	if anim_name == "dead":
		hide()
		TransitionScreen.fade_in()
