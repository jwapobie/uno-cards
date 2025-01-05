extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_selected.connect(select_option)
	if !OS.has_feature('neuro_integration'):
		get_parent().visible = false

func select_option(option: int) -> void:
	GameState.neuro_integration_mode = option
