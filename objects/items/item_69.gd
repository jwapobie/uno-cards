extends Item


func enable() -> void:
	event_handler.register_handler(Event.Type.CARD_PLAYABLE_CHECK, compare_69, EventCardPlayableCheck.Order.OVERRIDE, index)
	event_handler.register_handler(Event.Type.CARD_SCORED, score, EventCardScored.Order.POST_BASE_VALUE, index)

func compare_69(event :EventCardPlayableCheck):
	if event.last_card:
		if event.last_card.base_value == 6 and event.card.base_value == 9:
			event.is_playable = true
		elif event.last_card.base_value == 9 and event.card.base_value == 6:
			event.is_playable = true
			
func score(event :EventCardScored):
	if event.card.base_value == 9:
		var left_card := GameState.find_left_card(event.card_num, event.player_id)
		if left_card and left_card.base_value == 6:
			var score_create := EventScoreMultiCreated.new()
			score_create.player_id = event.player_id
			score_create.multiplier = 2.0
			score_create.visual_source = self
			if event.player_id == -1:
				score_create.extra_trigger_anim = [event.card_object, GameState.find_left_card_obj(event.card_num)]
			EventBus.queue_event(score_create, true)
	elif event.card.base_value == 6:
		var left_card := GameState.find_left_card(event.card_num, event.player_id)
		if left_card and left_card.base_value == 9:
			var score_create := EventScoreCreated.new()
			score_create.player_id = event.player_id
			score_create.score_amount = 10
			score_create.visual_source = self
			if event.player_id == -1:
				score_create.extra_trigger_anim = [event.card_object, GameState.find_left_card_obj(event.card_num)]
			EventBus.queue_event(score_create, true)
