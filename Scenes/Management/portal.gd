extends Area2D

@export var scene_path: String = ""

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"):
		TransitionScreen.target_path = scene_path 
		body.sprite.action_behavior("dead")
		body.set_physics_process(false)
