extends Item

func enable() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, set_values, EventHandPlayed.Order.PRE_SCORING, index)

func set_values(event :EventHandPlayed):
	for card in event.cards:
		match card.base_value:
			1 : card.value = 5
			2 : card.value = 5
			3 : card.value = 5
			4 : card.value = 5
			5 : card.value = 5
			6 : card.value = 5
			7 : card.value = 5
			8 : card.value = 5
			9 : card.value = 5
	if event.played_by_id == -1:
		play_scoring_anim()
