extends Object
class_name Event

var type :Type = Type.NONE
var queue_order :int
var is_blocking :bool = false # set to true when this event should block other event until event_resolved is sent
var is_resolved :bool = false # call set_resolved() from a handler when the handler resolved this event
var is_canceled :bool = false

var subqueue :Array[Event]

signal event_resolved

enum Type {
	NONE,
	_TEST_BUTTON_PRESSED,
	DAMAGE,
	CARD_DRAW,
	CARD_PLAYABLE_CHECK,
	CARD_PLAYED,
	HAND_PLAYED
}

static var type_lookup = {
	Type.DAMAGE : EventDamage,
}

func get_type() -> Event.Type:
	return type

func get_type_name() -> String:
	return Type.find_key(type)
	
func set_resolved():
	is_resolved = true
	event_resolved.emit()
	is_blocking = false