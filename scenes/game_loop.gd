extends Control

var deck: CardDeck
@onready var event_handler: EventHandler = $EventHandler
var gameplay: Gameplay
const gameplay_prefab := preload('res://scenes/gameplay.tscn')
var items :Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.register_handler(Event.Type.UPGRADE_SELECTED, on_upgrade_selected, 10, 0)
	deck = CardDeck.new_deck()
	new_round()

func new_round() -> void:
	GameState.round_num += 1
	if gameplay:
		gameplay.queue_free()
		gameplay = null
	deck.reset()
	gameplay = gameplay_prefab.instantiate()
	gameplay.deck = deck
	gameplay.turn = GameState.round_num
	add_child(gameplay)
	gameplay.set_items(items)

func on_upgrade_selected(event: EventUpgradeSelected) -> void:
	items.append(event.upgrade_item)
	new_round()
