extends Control
class_name Gameplay

@onready var event_handler: EventHandler = $EventHandler
@onready var continue_button: Button = $ContinueButton
@onready var card_hand: CardHand = %CardHand
@onready var upgrade_screen: UpgradeScreen = $UpgradeScreen

var deck: CardDeck


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !deck:
		printerr("Deck not configured, using default deck. Launch gameplay from Game Loop scene")
		deck = CardDeck.new_deck()
		deck.reset()
	continue_button.pressed.connect(_show_upgrades)
	continue_button.visible = false
	event_handler.register_handler(Event.Type.HAND_PLAYED, _after_hand_played, EventHandPlayed.Order.POST_SCORING, 0)
	draw_count(7)

func draw_count(num: int) -> void:
	for i in range(num):
		_draw_card()
		await get_tree().create_timer(0.1).timeout

func _draw_card() -> void:
	var card := deck.draw_one()
	if card:
		card_hand.add_card(card)

func _after_hand_played(event: EventHandPlayed) -> void:
	if event.played_by_id == 0:
		continue_button.visible = true

func _show_upgrades() -> void:
	upgrade_screen.visible = true
	upgrade_screen.show_upgrades()
