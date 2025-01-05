extends Control
class_name Gameplay

const REVIEW_SCREEN = preload("res://objects/review_screen/review_screen.tscn")

@onready var event_handler: EventHandler = $EventHandler
@onready var continue_button: Button = $ContinueButton
@onready var card_hand: CardHand = %CardHand
@onready var upgrade_screen: UpgradeScreen = $UpgradeScreen
@onready var items_container: Control = %ItemsContainer
@onready var past_hands: PastHands = $PastHands

@onready var turn_count_label: Label = %TurnCountLabel
var turn :int
static var anim_time_multiplier = 1.0
static var hand_played :bool = false

var deck: CardDeck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_played = false
	if !deck:
		printerr("Deck not configured, using default deck. Launch gameplay from Game Loop scene")
		deck = CardDeck.new_deck()
		deck.reset()
	continue_button.pressed.connect(_show_upgrades)
	continue_button.visible = false
	event_handler.register_handler(Event.Type.HEALTH_CHANGES_FINISHED, _after_health_changes_finished)
	turn_count_label.text = str(turn)
	draw_count(7)
	await get_tree().create_timer(2).timeout
	card_hand.tell_neuro_about_hand()

func set_items(items :Array[PackedScene]) -> void:
	for i in items.size():
		var item = items[i]
		var new_item := item.instantiate() as Item
		items_container.add_item(new_item)
		new_item.index = i
		new_item.enable()

func draw_count(num: int) -> void:
	for i in range(num):
		_draw_card()
		await get_tree().create_timer(0.1).timeout

func _draw_card() -> void:
	var card := deck.draw_one()
	if card:
		card_hand.add_card(card)

func _after_health_changes_finished(event: EventHealthChangesFinished) -> void:
	GameState.round_scoring_finished()
	await get_tree().create_timer(0.2).timeout
	if GameState.health <= 0:
		_end_game()
	else:
		if GameState.round_num == GameState.goal_rounds:
			var review_screen := REVIEW_SCREEN.instantiate()
			add_child(review_screen)
			review_screen.show_run_complete_screen()
		continue_button.visible = true

func _show_upgrades() -> void:
	GameState.save_this_round_hand()
	past_hands.populate_hands_list()
	upgrade_screen.visible = true
	upgrade_screen.show_upgrades()
	$ShaderBg.z_index = 5
	items_container.z_index = upgrade_screen.z_index

func _end_game() -> void:
	var review_screen := REVIEW_SCREEN.instantiate()
	add_child(review_screen)
	review_screen.show_game_over_screen()
