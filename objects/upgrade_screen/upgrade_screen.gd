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
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const ITEM_SELECTION = preload("res://objects/tooltip/item_selection.tscn")

var buttons: Array[Button] = []
var num_upgrades := 3

var neuro_action_window: ActionWindow

var items_have_changed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("no_particles"):
		gpu_particles_2d.visible = false

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
	if GameState.neuro_integration_mode != GameState.NEURO_INTEGRATION_MODE.Off:
		GameState.neuro_wait_started.emit()
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
	var item_select_callbacks: Array[ItemAndSelectCallback]= []
	for item in picked:
		var upgrade_item :Item = item.instantiate()
		var new_button = ITEM_SELECTION.instantiate()
		new_button.custom_minimum_size = Vector2(0, 160)
		var on_select := on_upgrade_selected.bind(item, upgrade_item.is_unique, new_button)
		new_button.pressed.connect(on_select)
		new_button.mouse_entered.connect(on_button_hover.bind(upgrade_item))
		new_button.mouse_exited.connect(on_button_unhover.bind(upgrade_item))
		new_button.add_child(upgrade_item)
		upgrade_item.visible = false
		upgrade_buttons.add_child(new_button)
		new_button.set_item(upgrade_item)
		
		var item_select_callback := ItemAndSelectCallback.new()
		item_select_callback.item = upgrade_item
		item_select_callback.select_callback = on_select
		item_select_callbacks.append(item_select_callback)
	
	await get_tree().create_timer(0.5).timeout
	create_actions(item_select_callbacks)

func on_upgrade_selected(item: PackedScene, is_unique :bool, button: ItemSelection) -> void:
	for child in upgrade_buttons.get_children():
		var sel := child as ItemSelection
		if sel:
			sel.button.disabled = true
	button.play_pressed_anim()
	audio_stream_player_2d.play()
	var time_wait = 0.8 if GameState.neuro_integration_mode == GameState.NEURO_INTEGRATION_MODE.Off else 1.2
	await get_tree().create_timer(time_wait).timeout

	var event := EventUpgradeSelected.new()
	event.upgrade_item = item
	EventBus.queue_event(event)
	if is_unique:
		GameState.upgrades_block.append(upgrade_prefabs.find(item))
	if GameState.neuro_integration_mode != GameState.NEURO_INTEGRATION_MODE.Off:
		GameState.neuro_wait_ended.emit()


func on_button_hover(item: Item) -> void:
	item.index = 100
	item.enable()
	items_have_changed = true

func on_button_unhover(item: Item) -> void:
	item.disable()
	items_have_changed = true

class ItemAndSelectCallback:
	var item: Item
	var select_callback: Callable

func create_actions(picked: Array[ItemAndSelectCallback]) -> void:
	if !self or GameState.neuro_integration_mode == GameState.NEURO_INTEGRATION_MODE.Off:
		return
	neuro_action_window = ActionWindow.new(self)
	var action := create_item_selection_action(neuro_action_window, picked)
	var item_descriptions = ''
	for element in picked:
		var item := element.item
		item_descriptions += describe_item(item) + '\n'
	neuro_action_window.set_context(item_descriptions)
	neuro_action_window.add_action(action)
	neuro_action_window.set_end(20)
	neuro_action_window.set_force(15, "Select an upgrade to proceed.", '')
	neuro_action_window.register()
	
	await get_tree().create_timer(30).timeout
	if self:
		GameState.neuro_wait_ended.emit()


func describe_item(item: Item) -> String:
	return 'The item %s has the description: %s' % [item.item_name, LabelParser.parse_plaintext(item.description)]

func create_item_selection_action(action_window: ActionWindow, picked: Array[ItemAndSelectCallback]) -> NeuroAction:
	var action := SelectUpgradeAction.new(action_window)
	for pick in picked:
		action.items[pick.item.item_name] = pick.select_callback
	return action


func _exit_tree() -> void:
	NeuroActionHandler.unregister_actions([SelectUpgradeAction.new(null)])
