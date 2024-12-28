extends Node2D
class_name Item

@onready var event_handler: EventHandler = $EventHandler
@export_multiline var description :String

func play_scoring_anim():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.1*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	await tween.finished


func _on_tooltip_zone_mouse_entered() -> void:
	Tooltip.show_tooltip(description, global_position + Vector2(-25, 25))


func _on_tooltip_zone_mouse_exited() -> void:
	Tooltip.hide_tooltip()
