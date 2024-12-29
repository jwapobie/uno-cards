extends Event
class_name EventHealthChangeCreated

var visual_source: Node
var extra_trigger_anim :Array[Node]
var health_amount: int

func _init() -> void:
	type = Type.HEALTH_CHANGE_CREATED
	type_lookup[type] = EventHealthChangeCreated

func _to_string() -> String:
	return "<EventHealthChangeCreated> %s" % health_amount
