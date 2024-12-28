extends Node
@onready var event_handler: EventHandler = $EventHandler
@onready var score_number: Label = $ScoreNumber

var total_score: int
@export var player_id := 0

func _ready() -> void:
	event_handler.register_handler(Event.Type.SCORE_CREATED, on_score_added, 10)

func on_score_added(event: EventScoreCreated) -> void:
	if event.player_id == player_id:
		total_score += event.score_amount
		score_number.text = str(total_score)
