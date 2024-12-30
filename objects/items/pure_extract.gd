extends Item


# Called when the node enters the scene tree for the first time.
func enable() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, set_multiplier, EventHandPlayed.Order.POST_SCORING, index)


func set_multiplier(event :EventHandPlayed):
	var colors :Array[int] = [0, 0, 0, 0]
	for card in event.cards:
		colors[card.color] = 1
	var count :int = colors[0] + colors[1] + colors[2] + colors[3]
	
	var new_score := EventScoreMultiCreated.new()
	new_score.player_id = event.played_by_id
	match count:
		1: new_score.multiplier = 3.0
		2: new_score.multiplier = 1.5
		3: new_score.multiplier = 0.75
		4: new_score.multiplier = 0.5
	new_score.visual_source = self
	if event.played_by_id == -1:
		var cards :Array[Node] = []
		for card in GameState.played_hand:
			cards.append(card)
		new_score.extra_trigger_anim = cards
	EventBus.queue_event(new_score, true)
