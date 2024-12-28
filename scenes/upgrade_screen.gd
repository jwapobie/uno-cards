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

@onready var upgrade_buttons: VBoxContainer = $Panel/UpgradeButtons
var buttons: Array[Button] = []
var num_upgrades := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_upgrades()

func show_upgrades() -> void:
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
	var event := EventUpgradeSelected.new()
	event.upgrade_item = item
	EventBus.queue_event(event)
