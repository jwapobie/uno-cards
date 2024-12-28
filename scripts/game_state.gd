extends Node

var played_hand :Array[CardObject] = []:
	set(arr):
		played_hand = arr
		played_hand_cards = card_obj_arr_to_cards(arr)
var played_hand_cards: Array[Card] = []
var played_hands: Array = []

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
	var hand: Array[Card] = played_hand_cards if player_id == -1 else played_hands[player_id]
	if idx >= 1:
		return hand[idx - 1]
	else:
		return null

func find_right_card(idx : int, player_id: int) -> Card:
	var hand: Array[Card] = played_hand_cards if player_id == -1 else played_hands[player_id]
	if idx >= 0 and idx < hand.size() - 1:
		return hand[idx + 1]
	else:
		return null


func reset() -> void:
	played_hand = []
	played_hands = []

func save_this_round_hand() -> void:
	if played_hand.size() <= 0:
		return
	played_hands.append(card_obj_arr_to_cards(played_hand))
	played_hand = []

func card_obj_arr_to_cards(objs: Array[CardObject]) -> Array[Card]:
	var newarr: Array[Card] = []
	for card in objs:
		newarr.append(card.attached_card)
	return newarr
