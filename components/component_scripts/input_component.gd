extends Node2D
class_name InputComponent

@export var unhandled_input_flag:bool = false

signal mouseHold(position)
signal mouseClick(position)
signal mouseRelease
signal spacePressed
signal rightMouseClick


func disable():
	Util.clear_callables_from_signals_in_node(self)
	get_parent().remove_child(self)

func enable():
	pass

func _unhandled_input(event):
	if !unhandled_input_flag:
		return
	handle_input_event(event)
	
func handle_input_event(event):
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



func _input(event):
	if unhandled_input_flag:
		return
	handle_input_event(event)
			
