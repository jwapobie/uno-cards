extends Item


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, score, EventHandPlayed.Order.POST_SCORING)

func score(event :EventHandPlayed):
	if GameState.played_hand.size() == 5:
		var new_score := EventScoreMultiCreated.new()
		new_score.player_id = event.played_by_id
		new_score.multiplier = 1.1
		new_score.visual_source = self
		var cards :Array[Node] = []
		for card in GameState.played_hand:
			cards.append(card)
		new_score.extra_trigger_anim = cards
		EventBus.queue_event(new_score, true)