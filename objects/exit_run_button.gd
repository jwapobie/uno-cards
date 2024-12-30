extends SoundButton

func _pressed() -> void:
	GameState.main_menu_requested.emit()
