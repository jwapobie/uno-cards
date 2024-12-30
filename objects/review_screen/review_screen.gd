extends Control
class_name ReviewScreen

@onready var bg: ColorRect = $BG
@onready var panel: Panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_screen_appear()

func animate_screen_appear() -> void:
	bg.modulate = Color.TRANSPARENT
	panel.position = Vector2(panel.position.x, panel.position.y+1000)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(bg, 'modulate', Color.WHITE, 0.2)
	tween.tween_property(panel, 'position', Vector2(panel.position.x, panel.position.y-1000), 0.2)
