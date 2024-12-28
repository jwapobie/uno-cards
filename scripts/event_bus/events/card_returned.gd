extends Event
class_name EventCardReturned

var card: CardObject
var new_last_card: Card

func _init() -> void:
	type = Type.CARD_RETURNED
	type_lookup[type] = EventCardReturned

func _to_string() -> String:
	return "<EventCardReturned> %s" % card.attached_card
