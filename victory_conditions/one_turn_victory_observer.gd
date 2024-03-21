class_name OneTurnVictoryObserver
extends VictoryObserver

func on_movement_of_player(player:Player) -> void:
	if !player.has_ball:
		return
	if player.my_field_square.zone != "endzone":
		return
	if player.my_field_square.player_team != "opponent":
		return
	

	


	
