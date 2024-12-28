extends Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.register_handler(Event.Type.CARD_SCORED, score_pairs, EventCardScored.Order.POST_BASE_VALUE)


func score_pairs(event :EventCardScored):
	var left_card := GameState.find_left_card(event.card_object)
	if left_card:
		if event.card_object.attached_card.color != left_card.attached_card.color:
			var score_create := EventScoreMultiCreated.new()
			score_create.player_id = event.player_id
			score_create.multiplier = 1.5
			score_create.visual_source = self
			score_create.extra_trigger_anim = [event.card_object, left_card]
			EventBus.queue_event(score_create, true)
