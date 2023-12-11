extends Label



func _on_end_setup_button_button_down():
	global_position = global_position + Vector2(0, 27)

func _on_end_setup_button_button_up():
	global_position = global_position + Vector2(0, -27)
