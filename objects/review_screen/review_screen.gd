extends Control
class_name ReviewScreen

@onready var bg: ColorRect = $BG
@onready var panel: Panel = $Panel
@onready var title_label: Label = %TitleLabel
@onready var exit_button: Button = %ExitButton
@onready var restart_button: Button = %RestartButton
@onready var close_button: Button = %CloseButton
@onready var gpu_particles_2d: GPUParticles2D = $Control/GPUParticles2D


var is_continue := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("no_particles"):
		gpu_particles_2d.visible = false
	close_button.pressed.connect(animate_screen_disappear)

func show_game_over_screen() -> void:
	title_label.text = "Game Over"
	exit_button.visible = true
	restart_button.visible = true
	close_button.visible = false
	animate_screen_appear()
	Context.send('Game over! You made it to round %s, with a max round score of %s and a cumulative score of %s.' % [
		GameState.round_num,
		GameState.max_round_score,
		GameState.cumulative_round_score
	], false)

func show_run_complete_screen() -> void:
	title_label.text = "You Win!"
	exit_button.visible = false
	restart_button.visible = true
	close_button.visible = true
	animate_screen_appear()
	Context.send('You win! You have reached round %s, with a max round score of %s and a cumulative score of %s.' % [
		GameState.round_num,
		GameState.max_round_score,
		GameState.cumulative_round_score
	], false)

func animate_screen_appear() -> void:
	visible = true
	bg.modulate = Color.TRANSPARENT
	panel.position = Vector2(panel.position.x, panel.position.y+1000)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(bg, 'modulate', Color.WHITE, 0.2)
	tween.tween_property(panel, 'position', Vector2(panel.position.x, panel.position.y-1000), 0.2)

func animate_screen_disappear() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(bg, 'modulate', Color.TRANSPARENT, 0.2)
	tween.tween_property(panel, 'position', Vector2(panel.position.x, panel.position.y+1000), 0.2)
	await tween.finished
	visible = false
	queue_free()
