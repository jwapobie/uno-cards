extends Event
class_name EventDamage

enum Order {INIT, ATTACKER_MODIFIERS, SEND_DAMAGE, DEFENDER_MODIFIERS, APPLY_DAMAGE}

enum SourceType {CARD_EFFECT, STATUS_EFFECT, GEAR_EFFECT, OTHER}

var damage_value :int
var source_type :SourceType
var target_id :int
#var target: CombatActor:
	#set(value):
		#target = value
		#target_id = target.ref_id

func _init() -> void:
	type = Event.Type.DAMAGE
	type_lookup[type] = EventDamage

func _to_string() -> String:
	return "<EventDamage>"
