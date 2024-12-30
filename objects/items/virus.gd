extends Item


func enable() -> void:
	event_handler.register_handler(Event.Type.CARD_SCORED, score, EventCardScored.Order.POST_BASE_VALUE, index)

			
func score(event :EventCardScored):
	if event.card.color != 1:
		var left_card := GameState.find_left_card(event.card_num, event.player_id)
		if left_card and left_card.color == 1:
			var score_create := EventScoreCreated.new()
			score_create.player_id = event.player_id
			score_create.score_amount = left_card.value
			score_create.visual_source = self
			if event.player_id == -1:
				score_create.extra_trigger_anim = [event.card_object, GameState.find_left_card_obj(event.card_num)]
			EventBus.queue_event(score_create, true)
		var right_card := GameState.find_right_card(event.card_num, event.player_id)
		if right_card and right_card.color == 1:
			var score_create := EventScoreCreated.new()
			score_create.player_id = event.player_id
			score_create.score_amount = right_card.value
			score_create.visual_source = self
			if event.player_id == -1:
				score_create.extra_trigger_anim = [event.card_object, GameState.find_right_card_obj(event.card_num)]
			EventBus.queue_event(score_create, true)
