extends Node

# Dictionary[Event.Type, Array[Callable]]
var handler_pool :Dictionary
var event_queue :Array[Event]
var current_queue_order: int = 0
var event_stack :Array[Event]

var filter :Array[Event.Type] = [Event.Type.CARD_SELECTED, Event.Type.HAND_PLAYED, Event.Type.CARD_PLAYABLE_CHECK]

func compare(a :Dictionary, b :Dictionary):
	if a["order"] == b["order"]:
		return a["priority"] < b["priority"]
	else:
		return a["order"] < b["order"]

func register(event_type :Event.Type, callable :Callable, order :int = 0, priority :int = 0):
	var handler_list :Array[Dictionary] = handler_pool[event_type]
	var order_placement = 0
	handler_list.append({"callable" : callable, "order" : order, "priority" : priority})
	handler_list.sort_custom(compare)
	#print("Callable %s registered to %s" % [callable, Event.Type.find_key(event_type)])

func match_callable(val :Dictionary, callable :Callable):
	return val["callable"] == callable

func unregister(event_type :Event.Type, callable :Callable):
	var handler_list :Array[Dictionary] = handler_pool[event_type]
	var i := 0
	while i < handler_list.size():
		if match_callable(handler_list[i], callable):
			handler_list.remove_at(i)
		else:
			i += 1
	#var i := handler_list.find_custom(match_callable.bind(callable))
	#if i >= 0:
		#handler_list.remove_at(i)
	#print("Callable %s unregistered for %s" % [callable, Event.Type.find_key(event_type)])

func queue_event(event :Event, triggered :bool = false):
	if !event_stack.is_empty() and triggered:
		event_stack.back().subqueue.push_back(event)
	else:
		event_queue.push_back(event)

var evlog :Array[Dictionary] = []
signal evlog_made(evlog :Array[Dictionary])

func fire_event(event :Event):
	if filter.has(event.type):
		evlog.append({depth = event_stack.size(), ev = event})
		print("* ".repeat(event_stack.size()) + " Event fired: %s" % [event])
		
	for handler in (handler_pool[event.type] as Array[Dictionary]):
		if event.is_canceled:
			if filter.has(event.type):
				#print("* ".repeat(event_stack.size()) + " Event canceled: %s" % [event])
				pass
			break
		handler["callable"].call(event)
		if event.is_blocking:
			await event.event_resolved
			event.is_blocking = false
	

	
func _ready() -> void:
	for event_type in Event.Type.values():
		handler_pool[event_type] = [] as Array[Dictionary]

func process_subqueue(e :Event):
	event_stack.append(e)
	await fire_event(e)
	
	for ee in e.subqueue:
		await process_subqueue(ee)
	event_stack.pop_back()



func _process(_delta: float) -> void:
	while !event_queue.is_empty() and event_stack.is_empty():
		await process_subqueue(event_queue.pop_front())
		if !evlog.is_empty():
			evlog_made.emit(evlog)
			evlog.clear()
