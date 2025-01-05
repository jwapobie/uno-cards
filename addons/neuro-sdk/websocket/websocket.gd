class_name Websocket
extends Node

const POLL_INTERVAL := 1.0 / 30.0
static var _socket: WebSocketPeer
static var _message_queue := MessageQueue.new()
static var _command_handler: CommandHandler
var _elapsed_time := 0.0

func _init() -> void:
	_command_handler = CommandHandler.new()
	self.add_child(_command_handler)
	_command_handler.name = "Command Handler"
	_command_handler.register_all()

func _ready() -> void:
	_ws_start()

func _process(delta) -> void:
	if _socket == null:
		return

	_elapsed_time += delta
	if _elapsed_time < POLL_INTERVAL:
		return
	_elapsed_time = 0

	_socket.poll()
	var state: int = _socket.get_ready_state()

	match state:
		WebSocketPeer.STATE_OPEN:
			_ws_read()
			_ws_write()
		WebSocketPeer.STATE_CLOSED:
			var code: int = _socket.get_close_code()
			push_warning("Websocket closed with code: %d" % [code])
			_ws_reconnect()

func _ws_start() -> void:
	push_warning("Initializing Websocket connection")

	if _socket != null:
		var state: int = _socket.get_ready_state();
		if state == WebSocketPeer.STATE_OPEN or state == WebSocketPeer.STATE_CONNECTING:
			_socket.close()

	var ws_url := OS.get_environment("NEURO_SDK_WS_URL")
	if not ws_url:
		push_error("NEURO_SDK_WS_URL environment variable is not set")
		return

	_socket = WebSocketPeer.new() # idk if i can reuse the same one
	var err: int = _socket.connect_to_url(ws_url)
	if err != OK:
		push_warning("Could not connect to websocket, error code %d" % [err])
		_ws_reconnect()

func _ws_reconnect() -> void:
	_socket = null
	await get_tree().create_timer(3).timeout
	_ws_start()

func _ws_read() -> void:
	while _socket.get_available_packet_count():
		var messageStr: String = _socket.get_packet().get_string_from_utf8()
		var json: JSON = JSON.new()
		var error: int = json.parse(messageStr)
		if error != OK:
			push_error("Could not parse websocket message: %s" % [messageStr])
			push_error("JSON Parse Error: %s at line %d" % [json.get_error_message(), json.get_error_line()])
			continue

		if typeof(json.data) != TYPE_DICTIONARY:
			push_error("Websocket message is not a dictionary: %s" % [messageStr])
			continue

		var message = IncomingData.new(json.data)

		var command = message.get_string("command")
		if not command:
			push_error("Websocket message does not have a command: %s" % [messageStr])
			continue

		var data := message.get_object("data", {})
		_command_handler.handle(command, data)

func _ws_write() -> void:
	while _message_queue.size() > 0:
		var message: OutgoingMessage = _message_queue.dequeue()
		Websocket._send_internal(message.get_ws_message())

static func send(message: OutgoingMessage) -> void:
	_message_queue.enqueue(message)

static func send_immediate(message: OutgoingMessage) -> void:
	if _socket == null or _socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		push_error("Cannot send immediate message, websocket is not connected")
		return
	_send_internal(message.get_ws_message())

static func _send_internal(message: WsMessage) -> void:
	var messageStr: String = JSON.stringify(message.get_data(), "  ", false)

	var err: int = _socket.send_text(messageStr)
	if err != OK:
		push_error("Could not send message: %s" % [message])
		push_error("Error code: %d" % [err])
