extends Area2D
class_name CardObject

@onready var card_visual: CardVisual = $CardVisual
@onready var highlight: Panel = %Highlight
@onready var outline: Panel = %Outline
@onready var event_handler: Node = $EventHandler

var is_playable :bool = true

@export var attached_card_default: Resource
var attached_card: Card
static var currently_hovered :CardObject
static var current_event :InputEvent

var picked :bool = false
static var is_card_picked :bool = false
var picked_offset :Vector2 = Vector2.ZERO
var is_draggable :bool = false


signal card_picked
signal card_hover
signal card_hover_off
signal card_picked_off

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	if !attached_card:
		attached_card = attached_card_default
	
	card_visual.card = attached_card

func _process(delta: float) -> void:
	if currently_hovered == self and is_draggable:
		outline.visible = true
	else:
		outline.visible = false


func _mouse_enter() -> void:
	pass

func _mouse_exit() -> void:
	if currently_hovered == self:
		currently_hovered = null


func _unhandled_input(event: InputEvent) -> void:
	if currently_hovered == self and not is_card_picked:
		#GameManager.preview_node.show_card(curr.card)
		pass
	elif is_card_picked:
		#GameManager.preview_node.show_card(curr.card, false)
		pass
	if is_draggable:
		if picked and event is InputEventMouseMotion:
			position = position + event.relative
		if event is InputEventMouseButton:
			if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				card_picked_off.emit()
				picked = false
				is_card_picked = false

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		if current_event != event:
			if not is_card_picked:
				currently_hovered = self
			current_event = event
			
	if event is InputEventMouseButton:
		if is_draggable and (currently_hovered == self) and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			card_picked.emit(self)
			picked = true
			picked_offset = get_local_mouse_position().rotated(rotation)
			is_card_picked = true

func play_scoring_anim():
	play_trigger_anim()
	await card_visual.play_scoring_anim()

func play_trigger_anim():
	var orig_scale = scale
	var tween = create_tween()
	tween.tween_property(self, "scale", orig_scale*1.1, 0.1*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel()
	tween.tween_property(self, "rotation_degrees", 5, 0.1*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", orig_scale, 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property(self, "rotation_degrees", 0, 0.2*Gameplay.anim_time_multiplier).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
