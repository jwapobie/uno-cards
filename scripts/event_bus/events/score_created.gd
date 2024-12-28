extends Event
class_name EventScoreCreated

var visual_source: Node
var score_amount: int
var player_id: int

func _init() -> void:
	type = Type.SCORE_CREATED
	type_lookup[type] = EventScoreCreated

func _to_string() -> String:
	return "<EventScoreCreated>"
