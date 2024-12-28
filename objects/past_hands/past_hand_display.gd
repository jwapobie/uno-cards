extends Control
class_name PastHandDisplay

var hand : Array[Card]
var player_id: int
var total_score: int = 0
@onready var rich_text_label: RichTextLabel = $Control/RichTextLabel
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_hand()

func show_hand() -> void:
	rich_text_label.clear()
	rich_text_label.push_paragraph(HORIZONTAL_ALIGNMENT_LEFT, Control.TEXT_DIRECTION_AUTO)
	for card in hand:
		rich_text_label.push_color(Card.COLOR_LOOKUP[card.color])
		rich_text_label.add_text(str(card.value))
		rich_text_label.pop()
	event_handler.register_handler(Event.Type.SCORE_CREATED, on_score_added, 10)
	event_handler.register_handler(Event.Type.SCORE_MULTI_CREATED, on_score_multi_added, 10)

func on_score_added(event: EventScoreCreated) -> void:
	if event.player_id == player_id:
		event.is_blocking = true
		total_score += event.score_amount
		score_number.text = str(total_score)
		event.set_resolved()

func on_score_multi_added(event: EventScoreMultiCreated) -> void:
	if event.player_id == player_id:
		event.is_blocking = true
		total_score *= event.multiplier
		score_number.text = str(total_score)
		event.set_resolved()
