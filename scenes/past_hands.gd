extends Control

@onready var past_hands_list: VBoxContainer = %PastHandsList
const PAST_HAND_DISPLAY = preload("res://objects/past_hands/past_hand_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_hands_list()

func populate_hands_list() -> void:
	var hands := GameState.played_hands
	for i in range(hands.size()):
		var hand = hands[i]
		var new_display := PAST_HAND_DISPLAY.instantiate() as PastHandDisplay
		new_display.hand = hand
		new_display.player_id = i
		past_hands_list.add_child(new_display)
	call_deferred("request_score_calculations")

func request_score_calculations() -> void:
	for i in range(GameState.played_hands.size()):
		var hand = GameState.played_hands[i]
		start_hand_score_calculate(hand, i)

func start_hand_score_calculate(hand: Array[Card], player_num: int) -> void:
	print(hand)
	var event := EventHandPlayed.new()
	event.cards = hand
	event.played_by_id = player_num
	EventBus.queue_event(event)
