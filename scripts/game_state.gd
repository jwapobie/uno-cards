extends Node

var played_hand :Array[CardObject]

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
