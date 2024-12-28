extends Event
class_name EventCardSelected

var card: CardObject

func _init() -> void:
	type = Type.CARD_SELECTED
	type_lookup[type] = EventCardSelected

func _to_string() -> String:
	return "<EventCardSelected> %s" % card.attached_card
