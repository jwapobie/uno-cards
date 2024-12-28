extends Node
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber
@onready var add_display: Node2D = $AddDisplay
@onready var gameplay: Gameplay = $"../../"

var total_score: int
@export var player_id := 0

func _ready() -> void:
	event_handler.register_handler(Event.Type.SCORE_CREATED, on_score_added, 10)

func on_score_added(event: EventScoreCreated) -> void:
	if event.player_id == player_id:
		event.is_blocking = true
		add_display.add_score(event.score_amount, event.visual_source)
		total_score += event.score_amount
		gameplay.total_score = total_score
		score_number.text = str(total_score)
		for trigger_anim in event.extra_trigger_anim:
			trigger_anim.play_trigger_anim()
		await event.visual_source.play_scoring_anim()
		#await get_tree().create_timer(0.2*Gameplay.anim_time_multiplier).timeout
		event.set_resolved()
