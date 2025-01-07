extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggled.connect(change_fullscreen)
	if OS.has_feature('web'):
		get_parent().visible = false

func change_fullscreen(on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if on else DisplayServer.WINDOW_MODE_WINDOWED)
