extends Event
class_name EventScoreMultiCreated

var visual_source: Node
var extra_trigger_anim :Array[Node]
var multiplier: float
var player_id: int

func _init() -> void:
	type = Type.SCORE_MULTI_CREATED
	type_lookup[type] = EventScoreMultiCreated

func _to_string() -> String:
	return "<EventScoreMultiCreated> %s" % multiplier
