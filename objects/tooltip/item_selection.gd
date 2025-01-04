extends Control
class_name ItemSelection

@onready var item_name: Label = %ItemName
@onready var item_description: RichTextLabel = %ItemDescription
@onready var texture_rect: TextureRect = %TextureRect
@onready var margin_container: MarginContainer = $MarginContainer

@onready var button: Button = %Button
@onready var cpu_particles_2d: CPUParticles2D = $Button/Control/CPUParticles2D
const HIGHLIHTED_BUTTON_STYLE = preload("res://objects/tooltip/highlihted_button_style.tres")

signal pressed

func set_item(item :Item):
	item_name.text = item.item_name
	item_description.parse_text(item.description)
	texture_rect.texture = item.get_item_img()

func _on_button_pressed() -> void:
	pressed.emit()

func play_pressed_anim() -> void:
	cpu_particles_2d.emitting = true
	button.add_theme_stylebox_override('disabled', HIGHLIHTED_BUTTON_STYLE)
