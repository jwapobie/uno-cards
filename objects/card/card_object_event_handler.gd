extends EventHandler

@export var card_object: CardObject

func _ready() -> void:
	register_handler(Event.Type.CARD_PLAYABLE_CHECK, check_playable_state, EventCardPlayableCheck.Order.PLAYABLE_RESOLVED)

func check_playable_state(event :EventCardPlayableCheck):
	if event.card == card_object.attached_card and event.current_slot < 5:
		%Highlight.visible = !event.is_playable
		card_object.is_playable = event.is_playable
