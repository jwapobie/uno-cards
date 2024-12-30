extends Resource
class_name Card



@export var color: int
@export var base_value :int
var value: int

func duplicate_card() -> Card:
	var card := Card.new()
	card.color = color
	card.base_value = base_value
	card.value = base_value
	return card

func _to_string() -> String:
	var color_str :String
	match color:
		0 : color_str = "red"
		1 : color_str = "green"
		2 : color_str = "blue"
		3 : color_str = "yellow"
	return "Card: %s (%s)" % [value, color_str] 

const COLOR_LOOKUP := [
	Color.MAROON,
	Color.MEDIUM_SPRING_GREEN,
	Color.DODGER_BLUE,
	Color.MOCCASIN,
]
