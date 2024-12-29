extends Control
class_name Gameplay

@onready var event_handler: EventHandler = $EventHandler
@onready var continue_button: Button = $ContinueButton
@onready var card_hand: CardHand = %CardHand
@onready var upgrade_screen: UpgradeScreen = $UpgradeScreen
@onready var items_container: Control = %ItemsContainer
@onready var past_hands: PastHands = $PastHands

@onready var score_goal_number: Label = %ScoreGoalNumber
var score_goal :int
@onready var turn_count_label: Label = %TurnCountLabel
var turn :int
static var anim_time_multiplier = 1.0

var deck: CardDeck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !deck:
		printerr("Deck not configured, using default deck. Launch gameplay from Game Loop scene")
		deck = CardDeck.new_deck()
		deck.reset()
	continue_button.pressed.connect(_show_upgrades)
	continue_button.visible = false
	event_handler.register_handler(Event.Type.SCORING_FINISHED, _after_scoring_finished)
	score_goal_number.text = str(GameState.health)
	turn_count_label.text = str(turn)
	draw_count(7)

func set_items(items :Array[PackedScene]) -> void:
	for item in items:
		var new_item := item.instantiate() as Item
		items_container.add_item(new_item)
		new_item.enable()

func draw_count(num: int) -> void:
	for i in range(num):
		_draw_card()
		await get_tree().create_timer(0.1).timeout

func _draw_card() -> void:
	var card := deck.draw_one()
	if card:
		card_hand.add_card(card)

func _after_scoring_finished(event: EventScoringFinished) -> void:
	if event.player_id == -1:
		await update_health()
		continue_button.visible = true

func _show_upgrades() -> void:
	GameState.save_this_round_hand()
	past_hands.populate_hands_list()
	upgrade_screen.visible = true
	upgrade_screen.show_upgrades()

func update_health() -> void:
	GameState.health += GameState.this_round_score
	score_goal_number.text = str(GameState.health)
	await get_tree().create_timer(1).timeout
	for enemy_hand in GameState.played_hands:
		GameState.health -= enemy_hand.score_current
		score_goal_number.text = str(GameState.health)
		await get_tree().create_timer(0.5).timeout
