extends HoldButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	hold_triggered.connect(quit_run)

func quit_run() -> void:
	GameState.main_menu_requested.emit()
