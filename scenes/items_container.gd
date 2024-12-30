extends Control
@onready var layout_container: HFlowContainer = $HFlowContainer


func add_item(item :Item):
	var new_control := Control.new()
	new_control.custom_minimum_size = Vector2(56, 56)
	new_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layout_container.add_child(new_control)
	new_control.add_child(item)
