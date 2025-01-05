@tool
extends Node2D
class_name LavaBall

var current_dir :float = 1
var speed :float = 1
@export var charge :float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < 0.5:
		current_dir = 1
	else:
		current_dir = -1
	scale.x = charge
	speed = randf_range(0.15, 1.5)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale.x += delta*5
	if scale.x > charge:
		scale.x = charge
