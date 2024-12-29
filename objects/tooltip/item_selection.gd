extends Control

@onready var item_name: Label = %ItemName
@onready var item_description: RichTextLabel = %ItemDescription
@onready var texture_rect: TextureRect = %TextureRect

@onready var button: Button = %Button

signal pressed

func set_item(item :Item):
	item_name.text = item.item_name
	item_description.parse_text(item.description)
	texture_rect.texture = item.get_item_img()


func _on_button_pressed() -> void:
	pressed.emit()
