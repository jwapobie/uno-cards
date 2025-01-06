extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected = GameState.neuro_integration_mode
	item_selected.connect(select_option)
	if OS.has_feature('web'):
		get_parent().disabled = true

func select_option(option: int) -> void:
	GameState.neuro_integration_mode = option
