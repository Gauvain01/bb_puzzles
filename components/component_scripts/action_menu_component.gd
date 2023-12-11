
extends VBoxContainer
class_name ActionMenuComponent
@export var blitz_button:Button
@export var move_button:Button
@export var block_button:Button
@export var end_player_action_button:Button
signal is_activated
signal is_deactivated



func clear_button_signals():
	
	for i in [blitz_button, move_button, block_button, end_player_action_button]:
		var button:Button = i
		var connectionsArray = button.pressed.get_connections()
		if len(connectionsArray) > 0:
			for j in connectionsArray:
				button.pressed.disconnect(j["callable"])
				

func deactivate():
	is_deactivated.emit()
	self.visible = false

func activate():
	is_activated.emit()
	visible = true
		
	
func get_blitz_signal() -> Signal:
	
	return blitz_button.pressed

func get_block_signal() -> Signal:
	return block_button.pressed

func get_move_signal() -> Signal:
	return move_button.pressed

func get_end_action_signal() -> Signal:
	return end_player_action_button.pressed






func _on_blitz_button_pressed():
	print("pressed")
