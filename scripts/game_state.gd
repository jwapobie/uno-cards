extends Node

class EnemyHand:
	var cards: Array[Card]
	var round_num: int
	var score_current: int

const STARTING_HEALTH = 10

var round_num: int = 1
var health: int = STARTING_HEALTH
var played_hand :Array[CardObject] = []:
	set(arr):
		played_hand = arr
		played_hand_cards = card_obj_arr_to_cards(arr)
var this_round_score: int = 0
var played_hand_cards: Array[Card] = []
var played_hands: Array[EnemyHand] = []

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
	played_hands = []
	round_num = 1
	this_round_score = 0
	health = STARTING_HEALTH

func save_this_round_hand() -> void:
	if played_hand.size() <= 0:
		return
	var enemy_hand := EnemyHand.new()
	enemy_hand.cards = card_obj_arr_to_cards(played_hand)
	enemy_hand.round_num = round_num
	played_hands.append(enemy_hand)
	played_hand = []

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
