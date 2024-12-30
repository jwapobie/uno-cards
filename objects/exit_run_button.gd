extends Button

func _pressed() -> void:
	GameState.exit_game_pressed.emit()
