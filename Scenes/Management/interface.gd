extends CanvasLayer

@onready var score: Label = get_node("Score")
@onready var health: Label = get_node("Health")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score.text = 'Score: 0'
	if TransitionScreen.current_score != 0:
		update_score(TransitionScreen.current_score)
	

func update_health(value: int) -> void:
	health.text = (str(value) + 'HP')

func update_score(new_score: int) -> void:
	score.text = 'Score: ' + str(new_score)
	
	
