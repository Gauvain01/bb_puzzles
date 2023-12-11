extends CheckButton
@export var player_team_tackle_check:CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tackle_zone_check_button_toggled(button_pressed):
	if button_pressed:
		player_team_tackle_check.set_pressed_no_signal(false)
		player_team_tackle_check.toggled.emit(false)
		
