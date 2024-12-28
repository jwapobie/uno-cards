extends HBoxContainer
@onready var speed_slow_button: Button = $SpeedSlowButton
@onready var speed_normal_button: Button = $SpeedNormalButton
@onready var speed_fast_button: Button = $SpeedFastButton

func _ready() -> void:
	speed_slow_button.pressed.connect(set_speed.bind(speed_slow_button))
	speed_normal_button.pressed.connect(set_speed.bind(speed_normal_button))
	speed_fast_button.pressed.connect(set_speed.bind(speed_fast_button))
	match Gameplay.anim_time_multiplier:
		0.5: speed_fast_button.button_pressed = true
		1.0: speed_normal_button.button_pressed = true
		3.0: speed_fast_button.button_pressed = true

func set_speed(button :Button):
	match button:
		speed_fast_button: Gameplay.anim_time_multiplier = 0.5
		speed_normal_button: Gameplay.anim_time_multiplier = 1.0
		speed_slow_button: Gameplay.anim_time_multiplier = 3.0
	speed_slow_button.button_pressed = speed_slow_button == button
	speed_normal_button.button_pressed = speed_normal_button == button
	speed_fast_button.button_pressed = speed_fast_button == button
