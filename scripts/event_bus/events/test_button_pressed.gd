extends Event
class_name EventTestButtonPressed

var button :Button

func _init() -> void:
	type = Type._TEST_BUTTON_PRESSED
	type_lookup[type] = EventTestButtonPressed
