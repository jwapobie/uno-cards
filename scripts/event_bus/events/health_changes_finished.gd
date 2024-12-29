extends Event
class_name EventHealthChangesFinished

func _init() -> void:
	type = Type.HEALTH_CHANGES_FINISHED
	type_lookup[type] = EventHealthChangesFinished

func _to_string() -> String:
	return "<EventHealthChangesFinished>"
