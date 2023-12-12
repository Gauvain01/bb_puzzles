extends Node

signal spacePressed
signal mouseClick
signal mouseRelease
signal rightMouseClick


var saasd




func _input(event):
	if event is InputEventKey:
		if event.key_label == KEY_SPACE and event.is_pressed():
			spacePressed.emit()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			mouseClick.emit(event.global_position)
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			mouseRelease.emit()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			rightMouseClick.emit()


func unsubscribe_from_all(callable:Callable):
	_unsubscribe_from_signal_array(spacePressed.get_connections(), callable)
	_unsubscribe_from_signal_array(mouseClick.get_connections(), callable)
	_unsubscribe_from_signal_array(mouseRelease.get_connections(),callable)
	_unsubscribe_from_signal_array(rightMouseClick.get_connections(),callable)
		

func _unsubscribe_from_signal_array(signal_array:Array, callable:Callable)->void:

	for sig_dic:Dictionary in signal_array:
		var sig:Signal =sig_dic["signal"]
		var sig_call:Callable = sig_dic["callable"]
		if callable == sig_call:
			sig.disconnect(sig_call)