extends Item


func _ready() -> void:
	event_handler.register_handler(Event.Type.CARD_PLAYABLE_CHECK, compare_69, EventCardPlayableCheck.Order.OVERRIDE)
	event_handler.register_handler(Event.Type.CARD_SCORED, score, EventCardScored.Order.POST_BASE_VALUE)

func compare_69(event :EventCardPlayableCheck):
	if event.last_card:
		if event.last_card.value == 6 and event.card.value == 9:
			event.is_playable = true
		elif event.last_card.value == 9 and event.card.value == 6:
			event.is_playable = true
			
func score(event :EventCardScored):
	if event.card_object.attached_card.value == 9:
		var left_card := GameState.find_left_card(event.card_object)
		if left_card and left_card.attached_card.value == 6:
			var score_create := EventScoreMultiCreated.new()
			score_create.player_id = event.player_id
			score_create.multiplier = 2.0
			score_create.visual_source = self
			score_create.extra_trigger_anim = [event.card_object, left_card]
			EventBus.queue_event(score_create, true)
	elif event.card_object.attached_card.value == 6:
		var left_card := GameState.find_left_card(event.card_object)
		if left_card and left_card.attached_card.value == 9:
			var score_create := EventScoreCreated.new()
			score_create.player_id = event.player_id
			score_create.score_amount = 10
			score_create.visual_source = self
			score_create.extra_trigger_anim = [event.card_object, left_card]
			EventBus.queue_event(score_create, true)
