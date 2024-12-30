extends Control

const main_menu := preload("res://scenes/main_menu.tscn")
const game_loop := preload("res://scenes/game_loop.tscn")
@onready var transition_rect: ColorRect = $TransitionRect

var active_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_main_menu()

func start_new_game() -> void:
	new_scene(game_loop)

func show_main_menu() -> void:
	new_scene(main_menu)


func new_scene(scene: PackedScene) -> void:
	if active_scene:
		active_scene.queue_free()
	active_scene = scene.instantiate()
	add_child(active_scene)

func animate_shutter_down() -> void:
	transition_rect.scale = Vector2.ONE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(transition_rect, 'scale', Vector2(1, 0), 0.25)
