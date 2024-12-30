extends Item


# Called when the node enters the scene tree for the first time.
func enable() -> void:
	event_handler.register_handler(Event.Type.CARD_PLAYABLE_CHECK, set_playable, EventCardPlayableCheck.Order.OVERRIDE)


func set_playable(event :EventCardPlayableCheck):
	if !event.last_card:
		return
	if event.card.color == 0 or event.last_card.color == 0:
		if event.last_card.base_value == event.card.base_value + 1 or event.last_card.base_value == event.card.base_value - 1:
			event.is_playable = true
			
