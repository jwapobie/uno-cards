extends Resource
class_name Card



@export var color: int
@export var value: int

func _to_string() -> String:
	var color_str :String
	match color:
		0 : color_str = "red"
		1 : color_str = "green"
		2 : color_str = "blue"
		3 : color_str = "yellow"
	return "Card: %s (%s)" % [value, color_str] 
