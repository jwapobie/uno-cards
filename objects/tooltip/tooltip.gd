extends Control


@onready var item_description: LabelParser = %ItemDescription


func show_tooltip(bb_text :String, position :Vector2):
	item_description.parse_text(bb_text)
	position.x = min(position.x, get_viewport_rect().size.x - $PanelContainer.size.x)
	position.y = min(position.y, get_viewport_rect().size.y - $PanelContainer.size.y)
	self.position = position
	visible = true

func hide_tooltip():
	visible = false
