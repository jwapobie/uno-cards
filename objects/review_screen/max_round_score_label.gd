extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(GameState.max_round_score)
