extends Event
class_name EventScoringFinished

var player_id: int

func _init() -> void:
	type = Type.SCORING_FINISHED
	type_lookup[type] = EventScoringFinished

func _to_string() -> String:
	return "<EventScoringFinished>"
