extends Control
class_name UpgradeScreen

var upgrade_prefabs :Array[PackedScene] = [
	preload("res://objects/items/item_color_multi.tscn"), 
	preload("res://objects/items/adjacent_colors.tscn"), 
	preload("res://objects/items/extra_score_1.tscn"), 
	preload("res://objects/items/item_69.tscn"), 
	preload("res://objects/items/item_pocky.tscn"), 
	preload("res://objects/items/reverse.tscn"),
	preload("res://objects/items/item_5_hand_multi.tscn"),
	
	]

@onready var bg: ColorRect = $BG
@onready var panel: Panel = $Panel
@onready var upgrade_buttons: VBoxContainer = $Panel/UpgradeButtons
var buttons: Array[Button] = []
var num_upgrades := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_upgrades()

func animate_screen_appear() -> void:
	bg.modulate = Color.TRANSPARENT
	panel.position = Vector2(panel.position.x, panel.position.y-1000)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(bg, 'modulate', Color.WHITE, 0.2)
	tween.tween_property(panel, 'position', Vector2(panel.position.x, panel.position.y+1000), 0.2)

func show_upgrades() -> void:
	animate_screen_appear()
	var upgrade_choices :Array[PackedScene] = upgrade_prefabs.duplicate()
	var picked :Array[PackedScene] = []
	for i in num_upgrades:
		upgrade_choices.shuffle()
		if upgrade_choices.is_empty():
			picked.append(preload("res://objects/items/item_blank.tscn"))
		else:
			picked.append(upgrade_choices.pop_back())
			
	for child in upgrade_buttons.get_children():
		child.queue_free()
	for item in picked:
		var upgrade_item :Item = item.instantiate()
		var new_button = Button.new()
		new_button.text = upgrade_item.description
		new_button.pressed.connect(on_upgrade_selected.bind(item))
		upgrade_buttons.add_child(new_button)

func on_upgrade_selected(item: PackedScene) -> void:
	for child in upgrade_buttons.get_children():
		var button := child as Button
		if button:
			button.disabled = true
	var event := EventUpgradeSelected.new()
	event.upgrade_item = item
	EventBus.queue_event(event)
