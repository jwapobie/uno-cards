extends Panel
class_name CardVisual

const base_stylebox = preload('res://objects/card/card_stylebox.tres')

const colors := [
	Color.MAROON,
	Color.MEDIUM_SPRING_GREEN,
	Color.DODGER_BLUE,
	Color.MOCCASIN,
]

var card: Card:
	set(value):
		card = value
		number.text = str(card.value)
		number_2.text = str(card.value)
		number_3.text = str(card.value)
		var col := card.color
		if col < 4:
			var stylebox := base_stylebox.duplicate()
			stylebox.bg_color = colors[col]
			add_theme_stylebox_override("panel", stylebox)

@onready var number: Label = $Number
@onready var number_2: Label = $Number2
@onready var number_3: Label = $Number3
