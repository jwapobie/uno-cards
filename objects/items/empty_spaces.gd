extends Item

# Called when the node enters the scene tree for the first time.
func enable() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, score_adjacent, EventHandPlayed.Order.PRE_SCORING, index)

func score_adjacent(event :EventHandPlayed):
	for i in 5 - event.cards.size():
		var score_create := EventScoreCreated.new()
		score_create.player_id = event.played_by_id
		score_create.score_amount = 6
		score_create.visual_source = self
		EventBus.queue_event(score_create, true)
