extends Control

@onready var past_hands_list: VBoxContainer = %PastHandsList
const PAST_HAND_DISPLAY = preload("res://objects/past_hands/past_hand_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_hands_list()

func populate_hands_list() -> void:
	var hands := GameState.played_hands
	for hand in hands:
		var new_display := PAST_HAND_DISPLAY.instantiate() as PastHandDisplay
		new_display.hand = hand
		past_hands_list.add_child(new_display)
