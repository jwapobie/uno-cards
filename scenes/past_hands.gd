extends Control
class_name PastHands

@onready var past_hands_list: VBoxContainer = %PastHandsList
@onready var empty_message: Panel = $ScrollContainer/VBoxContainer/EmptyMessage
@onready var event_handler: EventHandler = $EventHandler
const PAST_HAND_DISPLAY = preload("res://objects/past_hands/past_hand_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.register_handler(Event.Type.ITEMS_CHANGED, on_items_changed)
	populate_hands_list()

func populate_hands_list() -> void:
	for child in past_hands_list.get_children():
		child.queue_free()
	var enemy_turns := GameState.played_hands
	for i in range(enemy_turns.size()):
		var hand := enemy_turns[i].cards
		var new_display := PAST_HAND_DISPLAY.instantiate() as PastHandDisplay
		new_display.hand = hand
		new_display.player_id = i
		new_display.round_number = enemy_turns[i].round_num
		past_hands_list.add_child(new_display)
	if enemy_turns.size() > 0:
		empty_message.visible = false
	await get_tree().create_timer(0.05, false).timeout
	call_deferred("request_score_calculations")

func request_score_calculations() -> void:
	for child in past_hands_list.get_children():
		var past_display := child as PastHandDisplay
		if past_display:
			past_display.total_score = 0
	for i in range(GameState.played_hands.size()):
		var hand = GameState.played_hands[i].cards
		start_hand_score_calculate(hand, i)

func reset_base_values(cards :Array[Card]) -> void:
	for card in cards:
		card.value = card.base_value

func start_hand_score_calculate(hand: Array[Card], player_num: int) -> void:
	var event := EventHandPlayed.new()
	reset_base_values(hand)
	event.cards = hand
	event.played_by_id = player_num
	EventBus.queue_event(event)

func on_items_changed(event: EventItemsChanged) -> void:
	request_score_calculations()
