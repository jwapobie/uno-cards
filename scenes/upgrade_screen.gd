extends Control
class_name UpgradeScreen

@onready var upgrade_buttons: VBoxContainer = $Panel/UpgradeButtons
var buttons: Array[Button] = []
var num_upgrades := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_upgrades()

func show_upgrades() -> void:
	for child in upgrade_buttons.get_children():
		child.queue_free()
	for i in range(num_upgrades):
		var new_button = Button.new()
		new_button.text = "Upgrade %s" % str(i)
		new_button.pressed.connect(on_upgrade_selected.bind(i))
		upgrade_buttons.add_child(new_button)

func on_upgrade_selected(idx: int) -> void:
	var event := EventUpgradeSelected.new()
	event.upgrade_type = idx
	EventBus.queue_event(event)
