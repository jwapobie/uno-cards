extends Control
@onready var h_box_container: HBoxContainer = $HBoxContainer


func add_item(item :Item):
	var new_control := Control.new()
	new_control.custom_minimum_size = Vector2(64, 64)
	new_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h_box_container.add_child(new_control)
	new_control.add_child(item)
