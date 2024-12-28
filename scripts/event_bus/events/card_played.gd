extends Event
class_name EventCardPlayed

var card: CardObject

func _init() -> void:
	type = Type.CARD_PLAYED
	type_lookup[type] = EventCardPlayed

func _to_string() -> String:
	return "<EventCardPlayed>"
