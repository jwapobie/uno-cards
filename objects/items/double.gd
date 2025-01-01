extends Item

func enable() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, set_values, EventHandPlayed.Order.SCORING_MODIFIERS, index)

func set_values(event :EventHandPlayed):
	for card in event.cards:
		card.value *= 2
	if event.played_by_id == -1:
		play_scoring_anim()
		event.is_blocking = true
		for card_obj in event.card_objs:
			await card_obj.card_visual.value_override(card_obj.attached_card.value)
		event.set_resolved()
