extends Control
class_name PastHandDisplay

var hand : Array[Card]
var player_id: int
var total_score: int = 0
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber
@onready var card_containers: Array[Panel] = [
	$CardContainer/Panel,
	$CardContainer/Panel2,
	$CardContainer/Panel3,
	$CardContainer/Panel4,
	$CardContainer/Panel5,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_hand()

func show_hand() -> void:
	for i in range(hand.size()):
		show_card(hand[i], i)
	event_handler.register_handler(Event.Type.SCORE_CREATED, on_score_added, 10)
	event_handler.register_handler(Event.Type.SCORE_MULTI_CREATED, on_score_multi_added, 10)

func show_card(card: Card, idx: int) -> void:
	var panel := card_containers[idx]
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = Card.COLOR_LOOKUP[card.color]
	panel.add_theme_stylebox_override('panel', stylebox)
	var label: Label = panel.get_child(0)
	label.text = str(card.value)

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
