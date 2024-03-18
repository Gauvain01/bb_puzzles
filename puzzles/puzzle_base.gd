class_name PuzzleBase
extends Control

@export var field:Field
@export var ui:UiController

func victory_achieved():
	SceneController.change_scene(SCENE.VICTORY_SCREEN)

func set_teams(teams:Dictionary):

	for player in teams["player_team"]:
		field.player_team.add_child(player)
		if player.metadata["is_on_sideboard"]:
			field.sideboard.request_to_place_on_sideboard(player, player.metadata["coordinate_data"])
		else:
			field.request_to_place_on_field(player, field.get_field_square_by_grid_position(player.metadata["coordinate_data"]))
	
	for opponent in teams["opponent_team"]:
		field.opponent.add_child(opponent)
		field.request_to_place_opponent(opponent, opponent.metadata["coordinate_data"])
		
	#place players on field

func set_description(text:String):
	ui.description_label.text = text







