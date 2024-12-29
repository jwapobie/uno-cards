extends PanelContainer


@onready var item_description: RichTextLabel = $MarginContainer/ItemDescription


func show_tooltip(bb_text :String, position :Vector2):
	item_description.parse_text(bb_text)
	position.x = min(position.x, get_viewport_rect().size.x - item_description.size.x)
	position.y = min(position.y, get_viewport_rect().size.y - item_description.size.y)
	self.position = position
	visible = true

func hide_tooltip():
	visible = false
