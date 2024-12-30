extends Event
class_name EventHandPlayed

enum Order {PRE_SCORING, SCORING_MODIFIERS, PER_CARD, POST_HAND, POST_SCORING}

var cards: Array[Card] = []
var card_objs: Array[CardObject]
var played_by_id :int
var custom_tags :Dictionary

func _init() -> void:
	type = Type.HAND_PLAYED
	type_lookup[type] = EventHandPlayed

func _to_string() -> String:
	return "<EventHandPlayed>"
