extends Resource
class_name CardDeck

@export var all_cards: Array[Card]
var draw_pile: Array[Card]
var discard_pile: Array[Card]

func _init() -> void:
	all_cards = []
	draw_pile = []
	discard_pile = []

static func new_deck() -> CardDeck:
	var deck = CardDeck.new()
	for col in range(4):
		for val in range(10):
			for i in range(1):
				var card = Card.new()
				card.color = col
				card.value = val
				deck.all_cards.append(card)
	return deck

func reset() -> void:
	draw_pile.clear()
	discard_pile.clear()
	draw_pile.append_array(all_cards)

func draw_one() -> Card:
	if draw_pile.size() == 0:
		return null
	var idx = randi_range(0, draw_pile.size()-1)
	var card: Card = draw_pile.pop_at(idx)
	discard_pile.append(card)
	return card
