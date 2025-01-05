extends Control
@onready var texture_rect: TextureRect = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GameState.neuro_wait_started.connect(show_overlay)
	GameState.neuro_wait_ended.connect(hide_overlay)


func show_overlay() -> void:
	visible = true
	texture_rect.modulate = Color.TRANSPARENT
	var tween := create_tween()
	tween.tween_property(texture_rect, 'modulate', Color.WHITE, 0.25)

func hide_overlay() -> void:
	var tween := create_tween()
	tween.tween_property(texture_rect, 'modulate', Color.TRANSPARENT, 0.25)
	await tween.finished
	visible = false
