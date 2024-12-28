extends Node2D
const ADDITION_LABEL = preload("res://objects/score_counter/addition_label.tscn")
var last_label : Control

func add_score(score :int, score_emitter: Node):
	var new_label = ADDITION_LABEL.instantiate()
	new_label.set_text("+%s" % score)
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
