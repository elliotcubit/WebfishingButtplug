extends Node

const ButtplugDevice = preload("./ButtplugDevice.gd")

# export var websocket_url = "ws://127.0.0.1:12345"

var _client = WebSocketClient.new()
var connected = false
var _msg_id = 1

signal device_found(device)
signal device_removed(device)
signal scan_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

func _disconnect():
	if connected:
		_client.disconnect_from_host()
	
func _connect_to_server(websocket_url):
	if connected:
		# Weird behavior
		_client.disconnect_from_host()
		return
	print_debug("connecting to server at %s" % websocket_url)
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	print("connected")
	# buttplug uses text frames
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
		
func _connected(_protocol):
	_send("RequestServerInfo", {
		"ClientName": ProjectSettings.get_setting("application/config/name"),
		"MessageVersion": 1
	})
	
func _closed(_clean):
	print("_closed")
	connected = false
	for device in get_children():
		emit_signal("device_removed", device)
		device.queue_free()

func _add_device(info):
	var d = ButtplugDevice.new(info, self)
	d.name = "%d" % d.device_index
	add_child(d)
	emit_signal("device_found", d)

func _remove_device(info):
	print("_remove_device")
	var idx = info.DeviceIndex
	for device in get_children():
		if device.device_index == idx:
			emit_signal("device_removed", device)
			device.queue_free()

func _on_data():
	var msg = _client.get_peer(1).get_packet().get_string_from_utf8()
	var content = JSON.parse(msg).result
	print_debug(msg)
	for data in content:
		if "Error" in data:
			_on_err(msg)
		elif "DeviceAdded" in data:
			_add_device(data.DeviceAdded)
		elif "DeviceRemoved" in data:
			_remove_device(data.DeviceRemoved)
		elif "DeviceList" in data:
			for device in data.DeviceList.Devices:
				_add_device(device)
		elif "ServerInfo" in data:
			connected = true
			_send("RequestDeviceList", {})
			_scan()
		else:
			pass
		
func _on_err(msg):
	printerr(msg)

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

func _start_scan():
	_send("StartScanning", {})
	
func _stop_scan():
	_send("StopScanning", {})

func _scan():
	_start_scan()
	yield(get_tree().create_timer(30.0), "timeout")
	_stop_scan()

func _send(command, body):
	body.Id = _msg_id
	_msg_id += 1
	var msg = JSON.print([{
		command: body
	}])
	print_debug("sending msg %s" % msg)
	var buffer = msg.to_utf8()
	
	_client.get_peer(1).put_packet(buffer)
