extends Node

var played_hand :Array[CardObject] = []
var played_hands: Array = []

func find_left_card(card_object :CardObject) -> CardObject:
	var idx := played_hand.find(card_object)
	if idx >= 1:
		return played_hand[idx - 1]
	else:
		return null

func find_right_card(card_object :CardObject) -> CardObject:
	var idx := played_hand.find(card_object)
	if idx >= 0 and idx < played_hand.size() - 1:
		return played_hand[idx + 1]
	else:
		return null

func reset() -> void:
	played_hand = []
	played_hands = []

func save_this_round_hand() -> void:
	if played_hand.size() <= 0:
		return
	played_hands.append(card_obj_arr_to_cards(played_hand))
	print("Saved hand: %s" % str(played_hands.back()))
	played_hand = []

func card_obj_arr_to_cards(objs: Array[CardObject]) -> Array[Card]:
	var newarr: Array[Card] = []
	for card in objs:
		newarr.append(card.attached_card)
	return newarr
