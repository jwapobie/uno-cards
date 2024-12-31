extends Control
class_name UpgradeScreen

var upgrade_prefabs :Array[PackedScene] = [
	preload("res://objects/items/item_color_multi.tscn"), 
	preload("res://objects/items/adjacent_colors.tscn"), 
	preload("res://objects/items/extra_score_1.tscn"), 
	preload("res://objects/items/item_69.tscn"), 
	preload("res://objects/items/item_pocky.tscn"),
	preload("res://objects/items/item_5_hand_multi.tscn"),
	preload("res://objects/items/item_sequencer.tscn"),
	preload("res://objects/items/empty_spaces.tscn"),
	preload("res://objects/items/full_reverse.tscn"),
	preload("res://objects/items/flatline.tscn"),
	preload("res://objects/items/high_stakes.tscn"),
	preload("res://objects/items/double.tscn"),
	preload("res://objects/items/free_at_last.tscn"),
	preload("res://objects/items/virus.tscn"),
	preload("res://objects/items/snowball.tscn"),
	preload("res://objects/items/heart_heart.tscn"),
	preload("res://objects/items/pure_extract.tscn"),
	preload("res://objects/items/step_up.tscn"),
	preload("res://objects/items/tumbling_down.tscn"),
	preload("res://objects/items/blank_slate.tscn")
	]

var upgrades_block :Array[int] = []

@onready var bg: ColorRect = $BG
@onready var panel: Panel = $Panel
@onready var gpu_particles_2d: GPUParticles2D = $Control/GPUParticles2D
@onready var upgrade_buttons: VBoxContainer = $Panel/UpgradeButtons
const ITEM_SELECTION = preload("res://objects/tooltip/item_selection.tscn")

var buttons: Array[Button] = []
var num_upgrades := 3

var items_have_changed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("no_particles"):
		gpu_particles_2d.visible = false
	pass
	#show_upgrades()

func _process(_delta: float) -> void:
	if items_have_changed:
		items_have_changed = false
		var event := EventItemsChanged.new()
		EventBus.queue_event(event)

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
	for i in range(upgrade_choices.size() - 1, -1, -1):
		if GameState.upgrades_block.has(i):
			upgrade_choices.remove_at(i)
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
		var new_button = ITEM_SELECTION.instantiate()
		new_button.custom_minimum_size = Vector2(0, 160)
		new_button.pressed.connect(on_upgrade_selected.bind(item, upgrade_item.is_unique))
		new_button.mouse_entered.connect(on_button_hover.bind(upgrade_item))
		new_button.mouse_exited.connect(on_button_unhover.bind(upgrade_item))
		new_button.add_child(upgrade_item)
		upgrade_item.visible = false
		upgrade_buttons.add_child(new_button)
		new_button.set_item(upgrade_item)

func on_upgrade_selected(item: PackedScene, is_unique :bool) -> void:
	for child in upgrade_buttons.get_children():
		var button := child as Button
		if button:
			button.disabled = true
	var event := EventUpgradeSelected.new()
	event.upgrade_item = item
	EventBus.queue_event(event)
	if is_unique:
		GameState.upgrades_block.append(upgrade_prefabs.find(item))


func on_button_hover(item: Item) -> void:
	item.index = 100
	item.enable()
	items_have_changed = true

func on_button_unhover(item: Item) -> void:
	item.disable()
	items_have_changed = true
