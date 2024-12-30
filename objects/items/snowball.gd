extends Item

func enable() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, set_values, EventHandPlayed.Order.SCORING_MODIFIERS, index)

func set_values(event :EventHandPlayed):
	var apply_effect = false
	for card in event.cards:
		if apply_effect:
			card.value += 8
		if card.base_value == 8:
			apply_effect = true
	if event.played_by_id == -1:
		play_scoring_anim()
