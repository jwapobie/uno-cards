extends Panel
class_name CardVisual

const base_stylebox = preload('res://objects/card/card_stylebox.tres')

var card: Card:
	set(value):
		card = value
		number.text = str(card.value)
		number_2.text = str(card.value)
		number_3.text = str(card.value)
		var col := card.color
		if col < Card.COLOR_LOOKUP.size():
			var stylebox := base_stylebox.duplicate()
			stylebox.bg_color = Card.COLOR_LOOKUP[col]
			add_theme_stylebox_override("panel", stylebox)

@onready var number: Label = $Number
@onready var number_2: Label = $Number2
@onready var number_3: Label = $Number3

func play_scoring_anim():
	var tween = create_tween()
	tween.tween_property(number, "scale", Vector2(1.4, 1.4), 0.1*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(number, "scale", Vector2(1.0, 1.0), 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	await tween.finished
