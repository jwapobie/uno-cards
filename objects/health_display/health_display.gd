extends Control
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber
@onready var add_display: HealthAddDisplay = $HealthAddDisplay

var total_score: int

func _ready() -> void:
	total_score = GameState.health
	score_number.text = str(total_score)
	event_handler.register_handler(Event.Type.HEALTH_CHANGE_CREATED, on_score_added, 10)

func on_score_added(event: EventHealthChangeCreated) -> void:
	event.is_blocking = true
	add_display.add_health(event.health_amount, event.visual_source)
	total_score += event.health_amount
	GameState.health = total_score
	score_number.text = str(total_score)
	for trigger_anim in event.extra_trigger_anim:
		trigger_anim.play_trigger_anim()
	await event.visual_source.play_scoring_anim()
	await get_tree().create_timer(0.15*Gameplay.anim_time_multiplier).timeout
	event.set_resolved()
