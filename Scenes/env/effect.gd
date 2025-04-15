extends AnimatedSprite2D

# executa a animação
func _ready() -> void:
	is_playing()
	pass 


# Libera a animação
func on_animation_finished() -> void:
	queue_free()
	pass 
