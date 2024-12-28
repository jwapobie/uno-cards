extends Control

var deck: CardDeck
@onready var event_handler: EventHandler = $EventHandler
var gameplay: Gameplay
const gameplay_prefab := preload('res://scenes/gameplay.tscn')
var items :Array[PackedScene]
var score_goal :int = 15
var turn :int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.register_handler(Event.Type.UPGRADE_SELECTED, on_upgrade_selected, 10, 0)
	deck = CardDeck.new_deck()
	new_round()

func new_round() -> void:
	turn += 1
	if gameplay:
		score_goal = gameplay.total_score
		gameplay.queue_free()
		gameplay = null
	deck.reset()
	gameplay = gameplay_prefab.instantiate()
	gameplay.deck = deck
	gameplay.score_goal = score_goal
	gameplay.turn = turn
	add_child(gameplay)
	gameplay.set_items(items)

func on_upgrade_selected(event: EventUpgradeSelected) -> void:
	items.append(event.upgrade_item)
	new_round()
