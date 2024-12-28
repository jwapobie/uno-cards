extends Event
class_name EventUpgradeSelected

var upgrade_type: int

func _init() -> void:
	type = Type.UPGRADE_SELECTED
	type_lookup[type] = EventUpgradeSelected

func _to_string() -> String:
	return "<EventUpgradeSelected> %s" % str(upgrade_type)
