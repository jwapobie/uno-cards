extends Node2D
const ADDITION_LABEL = preload("res://objects/score_counter/addition_label.tscn")
var last_label : Control

func add_score(score :int, score_emitter: Node):
	var new_label = ADDITION_LABEL.instantiate()
	new_label.set_text("+%s" % score)
	new_label.pitch_scale_modifier = get_pitch_level(score+8, 16)
	add_child(new_label)
	var pos := global_position
	if score_emitter:
		var anchor := score_emitter.find_child("ScoreAnchor", false) as Node2D
		if anchor:
			pos = anchor.global_position
	new_label.global_position = pos
	if last_label:
		last_label.pop_off()
	last_label = new_label

func add_score_multi(multiplier :float, score_emitter: Node):
	var new_label = ADDITION_LABEL.instantiate()
	new_label.set_text("x%s" % multiplier)
	new_label.pitch_scale_modifier = get_pitch_level(multiplier, 1.5)
	add_child(new_label)
	var pos := global_position
	if score_emitter:
		var anchor := score_emitter.find_child("ScoreAnchor", false) as Node2D
		if anchor:
			pos = anchor.global_position
	new_label.global_position = pos
	if last_label:
		last_label.pop_off()
	last_label = new_label

func get_pitch_level(value: float, baseline: float) -> float:
	return sqrt(baseline / value)
