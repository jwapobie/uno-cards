extends OptionButton

var theme_options :Dictionary = {
	"None" : null,
	"Default" : preload("res://scenes/lava_colors/default1.tres"),
	"Low Contrast" : preload("res://scenes/lava_colors/low_contrast.tres"),
	"Evil" : preload("res://scenes/lava_colors/evil.tres"),
	"Dusk Dark" : preload("res://scenes/lava_colors/dark_dusk.tres"),
	"Nier" : preload("res://scenes/lava_colors/nier.tres"),
	"Sky" : preload("res://scenes/lava_colors/sky.tres"),
	"Blue Sky" : preload("res://scenes/lava_colors/blue_sky.tres"),
}
var options :Array[Texture2D] = []

signal theme_change(theme :Texture2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_selected.connect(select_option)
	theme_change.connect(%ShaderBg.change_theme)
	for key in theme_options.keys():
		add_item(key)
		options.append(theme_options[key])
	selected = options.find(GameState.current_theme)
	select_option(selected)

func select_option(option: int) -> void:
	theme_change.emit(options[option])
	GameState.current_theme = options[option]
