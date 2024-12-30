extends SoundButton
class_name HoldButton

@onready var progress_bar: ProgressBar = $ProgressBar
@export var press_duration := 0.5
var duration_held := 0.0
var is_held: bool = false

signal hold_triggered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	progress_bar.max_value = 1
	button_down.connect(on_press_down)
	button_up.connect(on_release)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if duration_held >= press_duration && is_held:
		is_held = false
		hold_triggered.emit()
	elif is_held:
		duration_held += delta
	else:
		duration_held = min(delta * 5 - duration_held, 0)
	if duration_held > 0:
		progress_bar.value = sqrt(duration_held / press_duration)
	else:
		progress_bar.value = 0

func on_press_down() -> void:
	is_held = true

func on_release() -> void:
	is_held = false
