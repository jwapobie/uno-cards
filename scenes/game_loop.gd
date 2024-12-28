extends Control

var deck: CardDeck
@onready var event_handler: EventHandler = $EventHandler
var gameplay: Gameplay
const gameplay_prefab := preload('res://scenes/gameplay.tscn')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.register_handler(Event.Type.UPGRADE_SELECTED, on_upgrade_selected, 10, 0)
	deck = CardDeck.new_deck()
	new_round()

func new_round() -> void:
	if gameplay:
		gameplay.queue_free()
		gameplay = null
	deck.reset()
	gameplay = gameplay_prefab.instantiate()
	gameplay.deck = deck
	add_child(gameplay)

func on_upgrade_selected(event: EventUpgradeSelected) -> void:
	new_round()
