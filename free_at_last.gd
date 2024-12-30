extends Item


func enable():
	event_handler.register_handler(Event.Type.CARD_PLAYABLE_CHECK, set_play_state, EventCardPlayableCheck.Order.OVERRIDE, index)

func set_play_state(event :EventCardPlayableCheck):
	if event.current_slot == 4:
		event.is_playable = true
