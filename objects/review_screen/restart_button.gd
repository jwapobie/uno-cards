extends SoundButton

func _pressed() -> void:
	GameState.new_run_requested.emit()
