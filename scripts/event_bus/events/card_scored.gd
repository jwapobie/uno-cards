extends Event
class_name EventCardScored

enum Order {PRE_BASE_VALUE, BASE_VALUE, POST_BASE_VALUE}

var player_id: int
var card: Card
var card_object :CardObject
var card_num: int
var triggered :bool = false

func _init() -> void:
	type = Type.CARD_SCORED
	type_lookup[type] = EventCardScored

func _to_string() -> String:
	return "<EventCardScored> %s" % card
