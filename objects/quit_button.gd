extends Button

func _ready() -> void:
	if OS.has_feature("web"):
		visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed() -> void:
	get_tree().quit()
