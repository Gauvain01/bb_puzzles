
extends VBoxContainer
class_name FollowStayMenuComponent
@export var stay_button:Button
@export var follow_button:Button


func clear_button_signals():
	for i in [stay_button, follow_button]:
		var button:Button = i
		var connectionsArray = button.pressed.get_connections()
		if len(connectionsArray) > 0:
			for j in connectionsArray:
				button.pressed.disconnect(j["callable"])

func deactivate():
	self.visible = false

func activate():
	visible = true
	
func get_stay_signal() -> Signal:
	return stay_button.pressed

func get_follow_signal() -> Signal:
	return follow_button.pressed



