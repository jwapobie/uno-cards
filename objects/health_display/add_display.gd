extends Node2D
class_name HealthAddDisplay

const ADDITION_LABEL = preload("res://objects/score_counter/addition_label.tscn")
var last_label : Control

func add_health(score :int, score_emitter: Node):
	var new_label := ADDITION_LABEL.instantiate() as AdditionLabel
	new_label.set_text("+%s" % score)
	var col = Color.LIME_GREEN if score > 0 else Color.INDIAN_RED
	new_label.set_color(col)
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
