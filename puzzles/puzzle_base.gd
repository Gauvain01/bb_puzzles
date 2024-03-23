class_name PuzzleBase
extends Control

@export var field:Field
@export var ui:UiController
var puzzle_type:int

func start_victory():
	SceneController.change_scene(SCENE.VICTORY_SCREEN)

func set_teams(teams:Dictionary):

	for player in teams["player_team"]:
		field.get_node("PlayerTeam").add_child(player)
		if player.metadata["is_on_sideboard"]:
			field.get_node("SideBoardController").request_to_place_on_sideboard(player, player.metadata["coordinate_data"])
		else:
			field.request_to_place_on_field(player, field.get_field_square_by_grid_position(player.metadata["coordinate_data"]))
	
	for opponent in teams["opponent_team"]:
		field.get_node("Opponent").add_child(opponent)
		field.request_to_place_opponent(opponent, opponent.metadata["coordinate_data"])
		
	#place players on field

func are_players_on_sideboard() -> bool:
	var sideboard:SideBoardController = field.get_node("SideBoardController")
	if len(sideboard.get_players()) > 0:
		return true
	return false

func set_description(text:String):
	ui.get_node("%DescriptionLabel").text = text







