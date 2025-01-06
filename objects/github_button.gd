extends Button


func _pressed() -> void:
	OS.shell_open("https://github.com/jwapobie/uno-cards")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(on_hover)
	mouse_exited.connect(on_unhover)

func on_hover():
	Tooltip.show_tooltip("https://github.com/jwapobie/uno-cards", get_global_mouse_position())

func on_unhover():
	Tooltip.hide_tooltip()
