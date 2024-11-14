extends Node

class Feature:
	var count = 0
	var step_count = [1]
	
export var device_name = ""
export var device_index = 0

var _vibrate: Feature = Feature.new()
var is_vibrator setget ,_is_vibrator

var _linear: Feature = Feature.new()
var is_stroker setget ,_is_stroker

var _server

func _init(deviceDefinition, server):
	_server = server
	device_name = deviceDefinition.DeviceName
	device_index = deviceDefinition.DeviceIndex
	
	for f in deviceDefinition.DeviceMessages:
		if f == "LinearCmd":
			_linear.count = deviceDefinition.DeviceMessages[f].FeatureCount
		if f == "VibrateCmd":
			_vibrate.count = deviceDefinition.DeviceMessages[f].FeatureCount
			if "StepCount" in deviceDefinition.DeviceMessages[f]:
				_vibrate.step_count = deviceDefinition.DeviceMessages[f].StepCount
			else:
				_vibrate.step_count = []
				for i in range(_vibrate.count):
					_vibrate.step_count.append(65535)
	
func _is_vibrator():
	return _vibrate.count > 0
	
func _is_stroker():
	return _linear.count > 0

"""
Sends a vibrate command to the connected server for this device
@param {float} speed
  intensity to vibrate the motor
@param {int} idx
  motor index, use -1 to vibrate all motors
"""
func do_vibrate(speed, idx):
	if not _is_vibrator():
		return
	
	var Speeds = []
	if idx == -1:
		for i in range(_vibrate.count):
			Speeds.append({
				"Index": i,
				"Speed": speed
			})
	else:
		Speeds.append({
			"Index": idx,
			"Speed": speed
		})

	_server._send("VibrateCmd", {
		"DeviceIndex": device_index,
		"Speeds": Speeds
	})

"""
Moves the stroker to a specific position
@async
@param {float} position
  location along the axis to move the stroker
@param {int} axis
  the index of which axis to move along
@param {int} duration
  time in milliseconds it should take to move along the axis
"""
func do_linear(position, axis, duration):
	if not _is_stroker():
		return

	_server._send("LinearCmd", {
		"DeviceIndex": device_index,
		"Vectors": [
			{
				"Index": axis,
				"Position": position,
				"Duration": duration,
			}
		]
	})
		
	# generate a timer based on the expected duration
	# for ease of use in coroutines for procedural animations
	yield(get_tree().create_timer(duration / 1000.0), "timeout")
