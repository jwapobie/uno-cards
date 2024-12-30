extends Button

func _pressed() -> void:
	GameState.main_menu_requested.emit()
