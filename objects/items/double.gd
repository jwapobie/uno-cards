extends Item

func enable() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, set_values, EventHandPlayed.Order.PRE_SCORING, index + 5000)

func set_values(event :EventHandPlayed):
	for card in event.cards:
		card.value *= 2
	if event.played_by_id == -1:
		play_scoring_anim()
