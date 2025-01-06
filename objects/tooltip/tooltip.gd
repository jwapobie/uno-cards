extends Control


@onready var item_description: LabelParser = %ItemDescription

var desired_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if visible:
		var realpos: Vector2 = Vector2(0,0)
		realpos.x = min(desired_position.x, get_viewport_rect().size.x - $PanelContainer.size.x)
		realpos.y = min(desired_position.y, get_viewport_rect().size.y - $PanelContainer.size.y)
		self.position = realpos

func show_tooltip(bb_text :String, position :Vector2):
	item_description.parse_text(bb_text)
	desired_position = position
	visible = true

func hide_tooltip():
	visible = false
