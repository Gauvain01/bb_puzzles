extends Node

signal spacePressed
signal mouseClick
signal mouseRelease
signal rightMouseClick

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