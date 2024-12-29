extends Event
class_name EventItemsChanged

func _init() -> void:
	type = Type.ITEMS_CHANGED
	type_lookup[type] = EventItemsChanged

func _to_string() -> String:
	return "<EventItemsChanged>"
