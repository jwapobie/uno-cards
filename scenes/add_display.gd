extends Node2D
const ADDITION_LABEL = preload("res://objects/score_counter/addition_label.tscn")
var last_label :Label

func add_score(score :int):
	var new_label = ADDITION_LABEL.instantiate()
	new_label.text = "+%s" % score
	add_child(new_label)
	if last_label:
		last_label.pop_off()
	last_label = new_label
