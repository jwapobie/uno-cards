extends Event
class_name EventCardPlayableCheck

enum Order {INTERRUPT, PLAYABLE_RESOLVED}

#var card_id :int
var last_card :Card
var card :Card
	#set(value):
		#card = value
		#card_id = value.ref_id
var played_by_id :int
var is_playable :bool = true

func _init() -> void:
	type = Type.CARD_PLAYABLE_CHECK
	type_lookup[type] = EventCardPlayableCheck

func _to_string() -> String:
	return "<EventCardPlayableCheck>"
