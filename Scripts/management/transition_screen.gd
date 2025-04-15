extends CanvasLayer

signal start_level # Signal para iniciar level

@onready var animation: AnimationPlayer = get_node("Animation")

var target_path: String

var current_score: int = 0
var current_health: int = 0

# Função para ativacr fade_in
func fade_in() -> void:
	animation.play("fade_in")


# função conectada ao sinal de animação finalizada para identificar qual amimção
# está sendo finalizada
func on_animation_animation_finished(anim_name: StringName) -> void:
	# Se for fade_in, animar fade_out e carregar outra cena
	if anim_name == "fade_in":
		var _change_scene: bool = get_tree().change_scene_to_file(target_path)
		animation.play("fade_out")
	# Se for fade_out, emitir sinal start_level
	if anim_name == "fade_out":
		var _start: bool = emit_signal("start_level")

func reset() -> void:
	current_score = 0
	current_health = 0
