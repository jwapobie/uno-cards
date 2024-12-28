extends PanelContainer

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel


func show_tooltip(bb_text :String, position :Vector2):
	rich_text_label.text = bb_text
	self.position = position
	visible = true

func hide_tooltip():
	visible = false
