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
	event_handler.register_handler(Event.Type.CARD_PLAYED, on_card_played)


func on_card_played(event: EventCardPlayed) -> void:
	var card_obj := event.card
	if current_cards.size() >= card_spaces.size():
		return
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
	hand_event.cards = cards
	EventBus.queue_event(hand_event)
