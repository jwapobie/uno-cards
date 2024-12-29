extends PanelContainer


@onready var item_description: RichTextLabel = $MarginContainer/ItemDescription


func show_tooltip(bb_text :String, position :Vector2):
	item_description.parse_text(bb_text)
	self.position = position
	visible = true

func hide_tooltip():
	visible = false
