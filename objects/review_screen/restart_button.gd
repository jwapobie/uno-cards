extends Button

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed() -> void:
	GameState.new_run_requested.emit()
