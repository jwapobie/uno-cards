extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
