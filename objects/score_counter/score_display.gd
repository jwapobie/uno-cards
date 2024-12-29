extends Node
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber
@onready var add_display: Node2D = $AddDisplay

var total_score: int
@export var player_id := -1

func _ready() -> void:
	event_handler.register_handler(Event.Type.SCORE_CREATED, on_score_added, 10)
	event_handler.register_handler(Event.Type.SCORE_MULTI_CREATED, on_score_multi_added, 10)
	event_handler.register_handler(Event.Type.SCORING_FINISHED, on_scoring_finished, EventScoringFinished.Order.PLAYER_SELF_EFFECT)

func play_scoring_anim():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	await tween.finished

func on_score_added(event: EventScoreCreated) -> void:
	if event.player_id == player_id:
		event.is_blocking = true
		add_display.add_score(event.score_amount, event.visual_source)
		total_score += event.score_amount
		GameState.this_round_score = total_score
		score_number.text = str(total_score)
		for trigger_anim in event.extra_trigger_anim:
			trigger_anim.play_trigger_anim()
		await event.visual_source.play_scoring_anim()
		event.set_resolved()

func on_score_multi_added(event: EventScoreMultiCreated) -> void:
	if event.player_id == player_id:
		event.is_blocking = true
		add_display.add_score_multi(event.multiplier, event.visual_source)
		total_score *= event.multiplier
		GameState.this_round_score = total_score
		score_number.text = str(total_score)
		for trigger_anim in event.extra_trigger_anim:
			trigger_anim.play_trigger_anim()
		await event.visual_source.play_scoring_anim()
		event.set_resolved()

func on_scoring_finished(event: EventScoringFinished) -> void:
	if event.player_id == player_id and player_id == -1:
		var health_event := EventHealthChangeCreated.new()
		health_event.visual_source = self
		health_event.health_amount = total_score
		EventBus.queue_event(health_event)
