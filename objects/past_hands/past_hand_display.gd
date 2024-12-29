extends Control
class_name PastHandDisplay

var hand : Array[Card]
var player_id: int
var total_score: int = 0
var round_number: int
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber
@onready var card_containers: Array[Panel] = [
	$CardContainer/Panel,
	$CardContainer/Panel2,
	$CardContainer/Panel3,
	$CardContainer/Panel4,
	$CardContainer/Panel5,
]
@onready var round_number_label: Label = $TurnLabelContainer/Label2
@onready var eliminate_label: Label = $ScoreNumber/EliminateLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_hand()

func show_hand() -> void:
	for i in range(hand.size()):
		show_card(hand[i], i)
	round_number_label.text = str(round_number)
	event_handler.register_handler(Event.Type.SCORE_CREATED, on_score_added, 10)
	event_handler.register_handler(Event.Type.SCORE_MULTI_CREATED, on_score_multi_added, 10)
	event_handler.register_handler(Event.Type.SCORING_FINISHED, on_scoring_finished)

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

func on_scoring_finished(event: EventScoringFinished) -> void:
	if event.player_id == -1:
		if GameState.this_round_score >= total_score:
			eliminate()
	elif event.player_id == player_id:
		GameState.played_hands[player_id].score_current = total_score

func eliminate() -> void:
	GameState.remove_enemy_hand(round_number)
	eliminate_label.modulate = Color.TRANSPARENT
	eliminate_label.visible = true
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.GRAY, 0.25)
	tween.tween_property(eliminate_label, "modulate", Color.WHITE, 0.25)
