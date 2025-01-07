extends Panel
class_name CardVisual

const base_stylebox = preload('res://objects/card/card_stylebox.tres')

var card: Card:
	set(value):
		card = value
		number.text = str(card.base_value)
		number_2.text = str(card.base_value)
		number_3.text = str(card.base_value)
		var col := card.color
		if col < Card.COLOR_LOOKUP.size():
			var stylebox := base_stylebox.duplicate()
			stylebox.bg_color = Card.COLOR_LOOKUP[col]
			add_theme_stylebox_override("panel", stylebox)

@onready var number: Label = $Number
@onready var number_2: Label = $Number2
@onready var number_3: Label = $Number3

@onready var slash_2: Label = $Slash2
@onready var number_2_new: Label = $Number2New
@onready var slash_3: Label = $Slash3
@onready var number_3_new: Label = $Number3New

func value_override(new_val :int):
	if new_val != card.base_value:
		number_2_new.text = str(new_val)
		number_3_new.text = str(new_val)
		if !slash_2.visible:
			await animate_slash()
		else:
			await animate_new_val()
		#slash_3.visible = true
	else:
		number_2.modulate = Color.WHITE
		number_2_new.visible = false
		number_3_new.visible = false
		slash_2.visible = false
		slash_3.visible = false

func animate_new_val():
	number_2_new.scale = Vector2.ONE*2
	var tween = create_tween()
	tween.tween_property(number_2_new, "scale", Vector2.ONE, 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished

func animate_slash():
	slash_2.visible = true
	slash_2.size.x = 1
	number_2_new.scale = Vector2.ONE*2
	var tween = create_tween()
	tween.tween_property(slash_2, "size:x", 45, 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC)
	tween.parallel()
	tween.tween_property(number_2, "modulate", Color.DIM_GRAY, 0.3*Gameplay.anim_time_multiplier)
	tween.tween_property(number_2_new, "visible", true, 0)
	tween.tween_property(number_2_new, "scale", Vector2.ONE, 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(0.2*Gameplay.anim_time_multiplier).timeout

func play_scoring_anim():
	var tween = create_tween()
	tween.tween_property(number, "scale", Vector2(1.4, 1.4), 0.1*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(number, "scale", Vector2(1.0, 1.0), 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	await tween.finished
