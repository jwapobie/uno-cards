extends Control
class_name PastHandDisplay

var hand : Array[Card]
@onready var rich_text_label: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_hand()

func show_hand() -> void:
	rich_text_label.clear()
	for card in hand:
		rich_text_label.push_color(Card.COLOR_LOOKUP[card.color])
		rich_text_label.add_text(str(card.value))
		rich_text_label.pop()
