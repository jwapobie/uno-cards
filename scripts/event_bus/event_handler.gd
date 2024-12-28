extends Node
class_name EventHandler

## Type: Dictionary[Callable, Event.Type]
var handler_table: Dictionary

func register_handler(handles_event :Event.Type, callable :Callable, order :int = 0, priority :int = 0):
	EventBus.register(handles_event, callable, order, priority)
	handler_table[callable] = handles_event
	
func unregister_handler():
	for callable in handler_table:
		EventBus.unregister(handler_table[callable], callable)
		handler_table.erase(callable)
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		unregister_handler()
