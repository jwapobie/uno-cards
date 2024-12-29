extends Item


func enable() -> void:
	event_handler.register_handler(Event.Type.CARD_SCORED, score_mult, EventCardScored.Order.POST_BASE_VALUE, 10)


func score_mult(event :EventCardScored):
	var prev_card := GameState.find_left_card(event.card_num, event.player_id)
	if prev_card and event.card.base_value == prev_card.base_value + 1:
		var score_create := EventScoreMultiCreated.new()
		score_create.player_id = event.player_id
		score_create.multiplier = 1.3
		score_create.visual_source = self
		if event.player_id == -1:
			score_create.extra_trigger_anim = [event.card_object, GameState.find_left_card_obj(event.card_num)]
		EventBus.queue_event(score_create, true)
