extends Item

func _ready() -> void:
	event_handler.register_handler(Event.Type.CARD_SCORED, set_scores, EventCardScored.Order.PRE_BASE_VALUE)

func set_scores(event :EventCardScored):
	if event.score_overriden:
		return
	if event.card.value == 1:
		var score_create := EventScoreCreated.new()
		score_create.player_id = event.player_id
		score_create.score_amount = 9
		score_create.visual_source = self
		score_create.extra_trigger_anim = [event.card_object]
		EventBus.queue_event(score_create, true)
		event.score_overriden = true
	elif event.card.value == 9:
		var score_create := EventScoreCreated.new()
		score_create.player_id = event.player_id
		score_create.score_amount = 1
		score_create.visual_source = self
		score_create.extra_trigger_anim = [event.card_object]
		EventBus.queue_event(score_create, true)
		event.score_overriden = true
