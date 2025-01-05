extends NeuroAction
class_name SelectUpgradeAction

var items: Dictionary

func _init(window: ActionWindow) -> void:
	super(window)

func _get_name() -> String:
	return "select upgrade"

func _get_description() -> String:
	return "select an upgrade which buffs both yourself and your enemy."

func _get_schema() -> Dictionary:
	return JsonUtils.wrap_schema({
		'selected_item': {
			"enum": items.keys()
		}
	})

func _validate_action(data: IncomingData, state: Dictionary) -> ExecutionResult:
	var item_name := data.get_string('selected_item')
	if items.has(item_name):
		state['item_name'] = item_name
		return ExecutionResult.success()
	return ExecutionResult.failure('could not find item matching this name!')

func _execute_action(state: Dictionary) -> void:
	var item_name = state['item_name']
	var item_callback = items[item_name] as Callable
	item_callback.call()
