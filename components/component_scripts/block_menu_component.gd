
extends VBoxContainer
class_name BlockMenuComponent
@export var push_button:Button
@export var pow_button:Button
@export var move_button:Button
@export var both_down_button:Button


func clear_button_signals():
	for i in [push_button, pow_button, move_button, both_down_button]:
		var button:Button = i
		var connectionsArray = button.pressed.get_connections()
		if len(connectionsArray) > 0:
			for j in connectionsArray:
				button.pressed.disconnect(j["callable"])

func deactivate():
	self.visible = false

func activate():
	visible = true
	

func get_push_signal() -> Signal:
	return push_button.pressed

func get_pow_signal() -> Signal:
	return pow_button.pressed

func get_move_signal() -> Signal:
	return move_button.pressed

func get_both_down_signal() -> Signal:
	return both_down_button.pressed




