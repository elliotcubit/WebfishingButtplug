extends Node

var Client = preload("./lib/ButtplugClient.gd")
var client = Client.new()
var strength = 0;
var device = "startingval"
var goodToGo = false

func _ready():
	# Fucking what?
	add_child(client)
	client.connect("device_found", self, "_set_device")
	client.connect("device_removed", self, "_unset_device")
	client._connect_to_server()
	
func _process(_delta):
	client._process(_delta)

const baseStrength = 0.05;

func _exit_tree():
	print("exit tree")
	
func _yank_hook():
	_set_strength(strength + 0.05)

func _reel_hook(reeling):
	if strength >= baseStrength:
		return
	_set_strength(baseStrength)

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
	_set_strength(baseStrength)

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
