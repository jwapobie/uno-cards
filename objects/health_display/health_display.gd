extends Control
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber
@onready var add_display: HealthAddDisplay = $HealthAddDisplay

var current_health: int

func _ready() -> void:
	current_health = GameState.health
	score_number.text = str(current_health)
	event_handler.register_handler(Event.Type.HEALTH_CHANGE_CREATED, on_score_added, 10)
	Context.send("Your current health is %s. If your health drops to 0, your run will end." % str(current_health), true)

func on_score_added(event: EventHealthChangeCreated) -> void:
	event.is_blocking = true
	add_display.add_health(event.health_amount, event.visual_source)
	current_health += event.health_amount
	GameState.health = current_health
	score_number.text = str(current_health)
	for trigger_anim in event.extra_trigger_anim:
		trigger_anim.play_trigger_anim()
	await event.visual_source.play_scoring_anim()
	await get_tree().create_timer(0.15*Gameplay.anim_time_multiplier).timeout
	event.set_resolved()
