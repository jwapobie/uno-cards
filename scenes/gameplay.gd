extends Control

@onready var card_hand: CardHand = %CardHand
var deck: CardDeck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck = CardDeck.new_deck()
	deck.reset()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw_card() -> void:
	var card := deck.draw_one()
	if card:
		card_hand.add_card(card)
