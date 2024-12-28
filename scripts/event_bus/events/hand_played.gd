extends Event
class_name EventHandPlayed

enum Order {PER_CARD, POST_HAND}

#var card_id :int
var cards: Array[Card]
	#set(value):
		#card = value
		#card_id = value.ref_id
var played_by_id :int
var is_playable :bool = true

func _init() -> void:
	type = Type.HAND_PLAYED
	type_lookup[type] = EventHandPlayed

func _to_string() -> String:
	return "<EventHandPlayed>"
