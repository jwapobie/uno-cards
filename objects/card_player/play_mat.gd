extends Node
class_name PlayMat

var play_slots := 5
@onready var card_spaces: Array[Control] = [
	$HBoxContainer/CardSpace/Control,
	$HBoxContainer/CardSpace2/Control,
	$HBoxContainer/CardSpace3/Control,
	$HBoxContainer/CardSpace4/Control,
	$HBoxContainer/CardSpace5/Control
]
var current_cards: Array[CardObject]
var has_played := false

@onready var event_handler: EventHandler = $EventHandler
@onready var play_hand_button: Button = $PlayHandButton
@onready var return_card_button: Button = $ReturnCardButton

func _ready() -> void:
	play_hand_button.pressed.connect(play_hand)
	return_card_button.pressed.connect(return_card)
	play_hand_button.disabled = true
	return_card_button.disabled = true
	event_handler.register_handler(Event.Type.CARD_SELECTED, on_card_selected)
	event_handler.register_handler(Event.Type.HAND_PLAYED, on_hand_play, EventHandPlayed.Order.PER_CARD, 10)
	event_handler.register_handler(Event.Type.CARD_SCORED, on_card_scored, EventCardScored.Order.BASE_VALUE)


func on_card_selected(event: EventCardSelected) -> void:
	var card_obj := event.card
	if !card_obj.is_playable or has_played:
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
	play_hand_button.disabled = false
	return_card_button.disabled = false


func return_card() -> void:
	var card := pop_one_card()
	if card:
		print("popped")
		var event := EventCardReturned.new()
		event.card = card
		if current_cards.size() > 0:
			event.new_last_card = current_cards.back().attached_card
			play_hand_button.disabled = false
			return_card_button.disabled = false
		else:
			play_hand_button.disabled = true
			return_card_button.disabled = true
		EventBus.queue_event(event)

func pop_one_card() -> CardObject:
	if current_cards.size() <= 0:
		return null
	var card_obj: CardObject = current_cards.pop_back()
	return card_obj

func play_hand() -> void:
	if current_cards.size() <= 0:
		return
	
	var cards: Array[Card] = []
	for card_obj in current_cards:
		var card := card_obj.attached_card
		cards.append(card)

	var hand_event := EventHandPlayed.new()
	hand_event.played_by_id = -1
	hand_event.cards = cards
	hand_event.card_objs = current_cards
	GameState.played_hand = current_cards
	EventBus.queue_event(hand_event)
	return_card_button.visible = false
	play_hand_button.visible = false
	has_played = true

func on_hand_play(event: EventHandPlayed) -> void:
	for i in range(event.cards.size()):
		var score_card := EventCardScored.new()
		score_card.card = event.cards[i]
		score_card.card_num = i
		if event.played_by_id == -1:
			score_card.card_object = event.card_objs[i]
		score_card.player_id = event.played_by_id
		EventBus.queue_event(score_card, true)
	var finish_event := EventScoringFinished.new()
	finish_event.player_id = event.played_by_id
	EventBus.queue_event(finish_event, false) # After all the scoring triggers finish

func on_card_scored(event: EventCardScored) -> void:
	var score_create := EventScoreCreated.new()
	score_create.player_id = event.player_id
	score_create.score_amount = event.card.value
	score_create.visual_source = event.card_object
	EventBus.queue_event(score_create, true)
