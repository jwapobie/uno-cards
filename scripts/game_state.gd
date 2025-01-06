extends Node

class EnemyHand:
	var cards: Array[Card]
	var round_num: int
	var score_current: int

const STARTING_HEALTH = 100

var round_num: int = 0
var max_round_score: int = 0
var cumulative_round_score: int = 0

var goal_rounds: int = 12

enum NEURO_INTEGRATION_MODE {
	Off,
	Coop
}
var neuro_integration_mode := NEURO_INTEGRATION_MODE.Off
signal neuro_wait_started
signal neuro_wait_ended

var current_theme :Texture2D = preload("res://scenes/lava_colors/default1.tres")

var health: int = STARTING_HEALTH
var played_hand :Array[CardObject] = []:
	set(arr):
		played_hand = arr
		played_hand_cards = card_obj_arr_to_cards(arr)
var this_round_score: int = 0
var played_hand_cards: Array[Card] = []
var played_hands: Array[EnemyHand] = []
var upgrades_block :Array[int]

signal main_menu_requested
signal new_run_requested

func find_left_card_obj(idx: int) -> CardObject:
	if idx >= 1:
		return played_hand[idx - 1]
	else:
		return null

func find_right_card_obj(idx: int) -> CardObject:
	if idx >= 0 and idx < played_hand.size() - 1:
		return played_hand[idx + 1]
	else:
		return null

func find_left_card(idx : int, player_id: int) -> Card:
	var hand: Array[Card] = played_hand_cards if player_id == -1 else played_hands[player_id].cards
	if idx >= 1:
		return hand[idx - 1]
	else:
		return null

func find_right_card(idx : int, player_id: int) -> Card:
	var hand: Array[Card] = played_hand_cards if player_id == -1 else played_hands[player_id].cards
	if idx >= 0 and idx < hand.size() - 1:
		return hand[idx + 1]
	else:
		return null


func reset() -> void:
	played_hand = []
	played_hands = [create_first_round_enemy_hand()]
	round_num = 0
	this_round_score = 0
	health = STARTING_HEALTH
	upgrades_block = []

func round_scoring_finished() -> void:
	max_round_score = max(max_round_score, this_round_score)
	cumulative_round_score += this_round_score

func save_this_round_hand() -> void:
	if played_hand.size() <= 0:
		return
	var enemy_hand := EnemyHand.new()
	enemy_hand.cards = []
	for card in card_obj_arr_to_cards(played_hand):
		enemy_hand.cards.append(card.duplicate_card())
	enemy_hand.round_num = round_num
	played_hands.append(enemy_hand)
	played_hand = []

func create_first_round_enemy_hand() -> EnemyHand:
	var card1 = Card.new()
	card1.base_value = 5
	card1.value = 5
	card1.color = 0
	var card2 = Card.new()
	card2.base_value = 5
	card2.value = 5
	card2.color = 0
	var card3 = Card.new()
	card3.base_value = 5
	card3.value = 5
	card3.color = 0
	var enemy_hand := EnemyHand.new()
	enemy_hand.cards = [card1, card2, card3]
	enemy_hand.round_num = 0
	enemy_hand.score_current = 15
	return enemy_hand

func card_obj_arr_to_cards(objs: Array[CardObject]) -> Array[Card]:
	var newarr: Array[Card] = []
	for card in objs:
		newarr.append(card.attached_card)
	return newarr

func remove_enemy_hand(round_num: int) -> void:
	var i := 0
	while i < played_hands.size():
		if played_hands[i].round_num == round_num:
			played_hands.remove_at(i)
		else:
			i += 1
