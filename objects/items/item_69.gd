extends Item


func _ready() -> void:
	event_handler.register_handler(Event.Type.CARD_PLAYABLE_CHECK, compare_69, EventCardPlayableCheck.Order.OVERRIDE)

func compare_69(event :EventCardPlayableCheck):
	if event.last_card:
		if event.last_card.value == 6 and event.card.value == 9:
			event.is_playable = true
		elif event.last_card.value == 9 and event.card.value == 6:
			event.is_playable = true
			
