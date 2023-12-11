class_name OneTurnVictoryObserver
extends VictoryObserver

func _ready():
	field.moved_player_during_play.connect(on_movement_of_player)


func on_movement_of_player(player:Player) -> void:
	if !player.has_ball:
		return
	if player.my_field_square.zone != "endzone":
		return
	if player.my_field_square.player_team != "opponent":
		return
	

	victory_condition_achieved.emit()
	


	
