extends Control
class_name AdditionLabel

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var sound: AudioStream
var pitch_scale_modifier: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sound:
		audio_stream_player_2d.stream = sound
	audio_stream_player_2d.pitch_scale = randf_range(0.95, 1.05) * pitch_scale_modifier
	audio_stream_player_2d.play()

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.1*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2.ZERO, 0.5*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()

func pop_off() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2.ZERO, 0.3*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	queue_free()

func set_text(str: String) -> void:
	$Label.text = str

func set_color(col: Color) -> void:
	$Label.add_theme_color_override("font_color", col)
