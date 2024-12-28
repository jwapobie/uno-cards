extends Event
class_name EventHandPlayed

enum Order {PRE_SCORING, PER_CARD, POST_HAND, POST_SCORING}

var cards: Array[Card]
var card_objs: Array[CardObject]
var played_by_id :int

func _init() -> void:
	type = Type.HAND_PLAYED
	type_lookup[type] = EventHandPlayed

func _to_string() -> String:
	return "<EventHandPlayed>"
