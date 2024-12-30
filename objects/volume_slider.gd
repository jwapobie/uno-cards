extends HSlider

@export var audio_bus_name := "Master"
@onready var _bus := AudioServer.get_bus_index(audio_bus_name)
@onready var sound: AudioStreamPlayer2D

var soundReady := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var audio_stream_player := find_child("AudioStreamPlayer2D")
	if audio_stream_player:
		sound = audio_stream_player as AudioStreamPlayer2D
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
	soundReady = true

func _value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
	if soundReady and sound:
		sound.play()
