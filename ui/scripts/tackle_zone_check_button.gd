extends CheckButton
@export var opponent_tackle_check: CheckButton




func _on_opponent_tackle_check_toggled(button_pressed):
	if button_pressed:
		opponent_tackle_check.set_pressed_no_signal(false)
		opponent_tackle_check.toggled.emit(false)
		
