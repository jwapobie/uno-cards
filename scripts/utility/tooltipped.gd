extends Control

@export_multiline var tooltip_content := ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(on_hover)
	mouse_exited.connect(on_unhover)

func on_hover():
	if tooltip_content.length() > 0:
		Tooltip.show_tooltip(tooltip_content, get_global_mouse_position())

func on_unhover():
	Tooltip.hide_tooltip()
