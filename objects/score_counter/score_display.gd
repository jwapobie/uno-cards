extends Node
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber
@onready var add_display: Node2D = $AddDisplay

var total_score: int
@export var player_id := -1

func _ready() -> void:
	event_handler.register_handler(Event.Type.SCORE_CREATED, on_score_added, 10)
	event_handler.register_handler(Event.Type.SCORE_MULTI_CREATED, on_score_multi_added, 10)

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
