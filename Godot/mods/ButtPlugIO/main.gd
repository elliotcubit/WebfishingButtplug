extends Node

const MOD_ID = "ButtPlugIO"

var config: Dictionary
var default_config: Dictionary = {
	"enabled": true,
	"websocket_url": "ws://127.0.0.1:12345",
	"enable_fishing_buzz": false,
	"reel_base_intensity": 0.05,
	"yank_intensity_increase": 0.05,
	"enable_scratch_buzz": false,
	"scratch_intensity": 0.25,
	"scratch_buzz_time": 1,
}

onready var TackleBox := $"/root/TackleBox"

var Client = preload("./lib/ButtplugClient.gd")
var client = Client.new()
var strength = 0;
var device = "startingval"
var goodToGo = false
var scratch_timer = Timer.new()

func _init_config():
	var saved_config = TackleBox.get_mod_config(MOD_ID)
	
	for key in saved_config:
		if not default_config.has(key):
			saved_config.erase(key)

	for key in default_config.keys():
		if not saved_config.has(key):
			saved_config[key] = default_config[key]

	config = saved_config

	TackleBox.set_mod_config(MOD_ID, config)

func _on_config_update(mod_id: String, new_config: Dictionary):
	if mod_id != MOD_ID:
		return

	if not config["enabled"] and new_config["enabled"]:
		client._disconnect()
		client = Client.new()
		add_child(client)
		client.connect("device_found", self, "_set_device")
		client.connect("device_removed", self, "_unset_device")
		
	config = new_config
	_connect()
	
	if not config["enabled"]:
		client._disconnect()
		return
		

func _connect():
	if config["enabled"]:
		client._connect_to_server(config["websocket_url"])

func _ready():
	add_child(scratch_timer)
	add_child(client)
	client.connect("device_found", self, "_set_device")
	client.connect("device_removed", self, "_unset_device")
	TackleBox.connect("mod_config_updated", self, "_on_config_update")
	scratch_timer.connect("timeout", self, "_done_scratching")
	_init_config()
	_connect()
	
func _process(_delta):
	client._process(_delta)

func _exit_tree():
	print("exit tree")
	
func _yank_hook():
	if not config["enable_fishing_buzz"]:
		return
	_set_strength(strength + config["yank_intensity_increase"])

func _reel_hook(reeling):
	if not config["enable_fishing_buzz"]:
		return
	if strength >= config["reel_base_intensity"]:
		return
	_set_strength(config["reel_base_intensity"])

func _set_device(dv):
	print("found device")
	device = dv
	goodToGo = true

func _unset_device(dv):
	# This is really stupid, but it works well enough
	# The loading time from the main menu to the game
	# is sometimes too long to not send pings to the server
	if not client.connected:
		client = Client.new()
		_ready()
	goodToGo = false

func _start_hook():
	_set_strength(config["reel_base_intensity"])

func _done_scratching():
	_set_strength(0)

func _scratch():
	if not config["enable_scratch_buzz"]:
		return
	_set_strength(config["scratch_intensity"])
	scratch_timer.start(config["scratch_buzz_time"])

func _set_strength(value):
	if strength == value:
		return
	print("set strength = ", value)
	strength = value
	if goodToGo:
		print("set device to vibrate")
		device.do_vibrate(strength, -1)

func _end_hook():
	_set_strength(0)
