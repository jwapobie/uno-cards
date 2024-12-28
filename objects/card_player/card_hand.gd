extends Node2D
class_name CardHand

var card_object_scene = preload("res://objects/card/card_object.tscn")

@export var pull_up_curve :Curve
var currently_picked :CardObject
var hovered_card :CardObject
@onready var draw_position: Node2D = $DrawPosition

var card_counter :int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	reposition()

func reposition():
	global_position.x = get_viewport().size.x/2
	#global_position.y = get_viewport().size.y

func add_card(card :Card):
	if not card:
		printerr("Error adding card to hand")
		return
	var new_card :CardObject = card_object_scene.instantiate()
	new_card.attached_card = card
	new_card.card_picked_off.connect(deselect_picked_card)
	new_card.card_picked.connect(select_picked_card)
	new_card.is_draggable = true
	new_card.position = draw_position.position
	
	$Cards.add_child(new_card)
	#$"../EventHandler".update_card_playable_state()
	update_placement(0)

func clear_hand():
	for card in $Cards.get_children():
		card.queue_free()

func get_card_position(x :float) -> int:
	var separation = min(1000.0/$Cards.get_child_count(), 160)
	return clampi((x + separation*$Cards.get_child_count()/2)/separation + 0.5, 0, $Cards.get_child_count())
	
		
func update_placement(delta :float):

	var cards = $Cards.get_children()
	var separation = min(1000.0/cards.size(), 160)
	var exp :float = exp(-22 * delta)
	var mouse_pos :Vector2 = get_local_mouse_position()
	mouse_pos.x += 50
	
	for i in range(cards.size()):
		if cards[i] != currently_picked:
			var new_x :float = i*separation - separation*cards.size()/2.0
			var new_y :float = pull_up_curve.sample_baked(cards[i].position.distance_to(mouse_pos)/300)*80
			
			cards[i].position = cards[i].position.lerp(Vector2(new_x, new_y), 1.0 - exp)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_placement(delta)
	if currently_picked and abs(currently_picked.position.y) < 240:
		if currently_picked.get_parent() == $Cards:
			$Cards.move_child(currently_picked, get_card_position(currently_picked.position.x))

func select_picked_card(card :CardObject):
	currently_picked = card

func get_cards() -> Array[Card]:
	var result :Array[Card] = []
	for card_object :CardObject in $Cards.get_children():
		result.append(card_object.attached_card)
	for card_object :CardObject in $Floating.get_children():
		result.append(card_object.attached_card)
	return result

func deselect_picked_card():
	if currently_picked and abs(currently_picked.position.y) < 240:
		$Cards.move_child(currently_picked, get_card_position(currently_picked.position.x))
	elif currently_picked:
		var card_played_event := EventCardPlayed.new()
		card_played_event.card = currently_picked
		EventBus.queue_event(card_played_event)
		currently_picked.is_draggable = false
		currently_picked.picked = false
		currently_picked.reparent($Floating)
	currently_picked = null	
	pass

func discard(card :Card):
	for card_object :CardObject in $Cards.get_children():
		if card_object.attached_card == card:
			if card_object == currently_picked:
				currently_picked = null
			card_object.queue_free()
			#$"../BattleManager".discard_pile.add_card(card)
	for card_object :CardObject in $Floating.get_children():
		if card_object.attached_card == card:
			card_object.queue_free()
			#$"../BattleManager".discard_pile.add_card(card)
		else:
			card_object.reparent($Cards)

func sort_hand() -> void:
	var sorted_cards := $Cards.get_children()
	sorted_cards.sort_custom(
		func(a: Node, b: Node):
			var a_card := a as CardObject
			var b_card := b as CardObject
			if a_card and b_card:
				if a_card.attached_card.color == b_card.attached_card.color:
					return a_card.attached_card.value < b_card.attached_card.value
				else:
					return a_card.attached_card.color < b_card.attached_card.color
			if a_card:
				return false
			if b_card:
				return true
			return a.name.naturalnocasecmp_to(b.name)
	)
	for card in $Cards.get_children():
		$Cards.remove_child(card)
	for card in sorted_cards:
		$Cards.add_child(card)

func _on_clear_hand_button_pressed() -> void:
	clear_hand() # Replace with function body.
