extends Item


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.register_handler(Event.Type.HAND_PLAYED, score_adjacent, EventHandPlayed.Order.PRE_SCORING)

func score_adjacent(event :EventHandPlayed):
	if event.card_objs.size() <= 1:
		return
	for i in event.card_objs.size() - 1:
		if event.card_objs[i].attached_card.color == event.card_objs[i+1].attached_card.color:
			var score_create := EventScoreCreated.new()
			score_create.player_id = event.played_by_id
			score_create.score_amount = 2
			score_create.visual_source = self
			score_create.extra_trigger_anim = [event.card_objs[i], event.card_objs[i+1]]
			EventBus.queue_event(score_create, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
