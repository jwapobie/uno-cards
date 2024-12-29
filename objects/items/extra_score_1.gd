extends Item


func enable() -> void:
	event_handler.register_handler(Event.Type.CARD_SCORED, extra_score, EventCardScored.Order.POST_BASE_VALUE)


func extra_score(event: EventCardScored) -> void:
	var score_create := EventScoreCreated.new()
	score_create.player_id = event.player_id
	score_create.score_amount = 2
	score_create.visual_source = self
	score_create.extra_trigger_anim = [event.card_object]
	EventBus.queue_event(score_create, true)
