extends Button
class_name SoundButton

var audio_player: AudioStreamPlayer2D
@export var sound_on_press := preload("res://audio/UI_Select_Plastic_6.wav")
@export_range(0, 10, 0.05) var pitch_scale: float = 1
@export var pitch_variance := 0.05
@export var size_sound_factor := 1.0
@export var volume_db := 0

func _ready() -> void:
	audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = sound_on_press
	audio_player.pitch_scale = pitch_scale
	audio_player.panning_strength = 0.25
	audio_player.volume_db = volume_db
	add_child(audio_player)

func size_pitch_modifier() -> float:
	return sqrt(50 / size.y) if size.y > 0 else 1

func _pressed():
	audio_player.pitch_scale = (pitch_scale + randf_range(-pitch_variance, pitch_variance)) * size_pitch_modifier()
	audio_player.play()
