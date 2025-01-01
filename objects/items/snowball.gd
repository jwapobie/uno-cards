extends Item

func enable() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, set_values, EventHandPlayed.Order.SCORING_MODIFIERS, index)

func set_values(event :EventHandPlayed):
	var apply_effect = false
	var idx :int = 0
	var modified_card_objs :Array[CardObject] = []
	for card in event.cards:
		if apply_effect:
			card.value += 8
			if event.played_by_id == -1:
				modified_card_objs.append(event.card_objs[idx])
		if card.base_value == 8:
			apply_effect = true
		idx += 1
	if event.played_by_id == -1:
		play_scoring_anim()
		event.is_blocking = true
		for card_obj in modified_card_objs:
			await card_obj.card_visual.value_override(card_obj.attached_card.value)
		event.set_resolved()
