extends Item


func enable() -> void:
	event_handler.register_handler(Event.Type.CARD_SCORED, score_again, EventCardScored.Order.POST_BASE_VALUE, 10)


func score_again(event :EventCardScored):
	if event.card.value == 1 and event.triggered == false:
		var double_scoring := EventCardScored.new()
		double_scoring.player_id = event.player_id
		double_scoring.card_object = event.card_object
		double_scoring.card = event.card
		double_scoring.card_num = event.card_num
		double_scoring.triggered = true
		EventBus.queue_event(double_scoring, true)
		if event.player_id == -1:
			play_scoring_anim()
