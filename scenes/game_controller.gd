extends Control

const main_menu := preload("res://scenes/main_menu.tscn")
const game_loop := preload("res://scenes/game_loop.tscn")
@onready var transition_rect: ColorRect = $TransitionRect

var active_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.main_menu_requested.connect(show_main_menu)
	GameState.new_run_requested.connect(start_new_game)
	show_main_menu()

func start_new_game() -> void:
	new_scene(game_loop)

func show_main_menu() -> void:
	new_scene(main_menu)


func new_scene(scene: PackedScene) -> void:
	if active_scene:
		await animate_shutter_down()
		await get_tree().create_timer(0.3, true, true, true).timeout
		active_scene.queue_free()
	active_scene = scene.instantiate()
	add_child(active_scene)
	await animate_shutter_up()

func animate_shutter_down() -> void:
	transition_rect.scale = Vector2(1, 0)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(transition_rect, 'scale', Vector2(1, 1), 0.25)
	await tween.finished

func animate_shutter_up() -> void:
	transition_rect.scale = Vector2(1, 1)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(transition_rect, 'scale', Vector2(1, 0), 0.25)
	await tween.finished
