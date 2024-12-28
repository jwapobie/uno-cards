extends Node

var play_slots := 5
@onready var card_spaces: Array[Control] = [
	$HBoxContainer/CardSpace/Control,
	$HBoxContainer/CardSpace2/Control,
	$HBoxContainer/CardSpace3/Control,
	$HBoxContainer/CardSpace4/Control,
	$HBoxContainer/CardSpace5/Control
]
var current_cards: Array[CardObject]

@onready var event_handler: EventHandler = $EventHandler
@onready var play_hand_button: Button = $PlayHandButton

func _ready() -> void:
	play_hand_button.pressed.connect(play_hand)
	event_handler.register_handler(Event.Type.CARD_SELECTED, on_card_selected)
	event_handler.register_handler(Event.Type.HAND_PLAYED, on_hand_play, EventHandPlayed.Order.PER_CARD, 10)


func on_card_selected(event: EventCardSelected) -> void:
	var card_obj := event.card
	if !card_obj.is_playable:
		event.is_canceled = true
		return
	if current_cards.size() >= card_spaces.size():
		event.is_canceled = true
		return
	card_obj.is_draggable = false
	card_obj.picked = false
	var space := card_spaces[current_cards.size()]
	card_obj.reparent(space)
	var tween := card_obj.create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(card_obj, 'position', Vector2.ZERO, 0.25)
	current_cards.append(card_obj)


func play_hand() -> void:
	if current_cards.size() <= 0:
		return
	
	var cards: Array[Card] = []
	for card_obj in current_cards:
		var card := card_obj.attached_card
		cards.append(card)

	var hand_event := EventHandPlayed.new()
	hand_event.played_by_id = 0
	hand_event.cards = cards
	hand_event.card_objs = current_cards
	EventBus.queue_event(hand_event)
	play_hand_button.disabled = true

func on_hand_play(event: EventHandPlayed) -> void:
	for i in range(event.cards.size()):
		var score_create := EventScoreCreated.new()
		score_create.player_id = event.played_by_id
		score_create.score_amount = event.cards[i].value
		score_create.visual_source = event.card_objs[i]
		EventBus.queue_event(score_create)
