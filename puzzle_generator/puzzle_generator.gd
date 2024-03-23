class_name PuzzleGenerator
extends Node2D

@export var player_loader:PlayerLoader

var _puzzle_type_victory_observer_map = {
	PUZZLE_TYPE.SCORE:"res://"
	}

func generate(puzzle_data:PuzzleData) -> PuzzleBase:
	#instantiate empty puzzle 
	var puzzle:PuzzleBase = load("res://puzzle_generator/puzzle_prefab.tscn").instantiate()
	puzzle.get_node("Field").get_node("grid")._generate_field_squares()
	#load players from file
	var players:Dictionary = _load_players(puzzle_data, puzzle)
	#load players in to team 
	puzzle.set_teams(players)
	puzzle.puzzle_type = puzzle_data.get_puzzle_type()
	#spawn ball if on field
	if puzzle_data.is_ball_on_field():
		var square = puzzle.field.get_field_square_by_grid_position(
			Vector2(
				puzzle_data.get_ball_position()[0], puzzle_data.get_ball_position()[1]
				)
			)

		var bhc = NodeInspector.get_ball_holdable_component(square)
		puzzle.field.spawn_ball(bhc)
	#start ball observer
	puzzle.get_node("BallObserver").start_ball_observer()
	#connect victory_observer
	#var victory_observer_path = _puzzle_type_victory_observer_map[puzzle_data.get_puzzle_type()]
	#var victory_observer:VictoryObserver = load(victory_observer_path).instantiate()
	#puzzle.add_child(victory_observer)
	#victory_observer.set_up()
	#set puzzle information
	_load_puzzle_information(puzzle_data, puzzle)

	return puzzle
func change_to_generated_scene(puzzle:PuzzleBase):
	pass
	

func _load_players(puzzle_data:PuzzleData, puzzle:PuzzleBase) -> Dictionary:

	var output = {}
	var player_data = puzzle_data.get_player_team()
	var player_team_type = puzzle_data.get_player_team_type()

	var opponent_data =puzzle_data.get_opponent_team()
	var opponent_type = puzzle_data.get_opponent_team_type()

	var opponent_team_players = []
	var player_team_players = []

	for i in player_data:
		var player:Player = player_loader.load_player_by_player_type(player_team_type, i["type"])
		player = _set_up_player(player, i, false)
		player_team_players.append(player)
		if player.has_ball:
			var ball_holdable_component = NodeInspector.get_ball_holdable_component(player)
			puzzle.field.spawn_ball(ball_holdable_component)

	for i in opponent_data:
		var opponent:Player = player_loader.load_player_by_player_type(opponent_type, i["type"])
		opponent = _set_up_player(opponent, i, true)
		opponent_team_players.append(opponent)
		if opponent.has_ball:
			var ball_holdable_component = NodeInspector.get_ball_holdable_component(opponent)
			puzzle.field.spawn_ball(ball_holdable_component)

	output["player_team"] = player_team_players
	output["opponent_team"] = opponent_team_players
	return output


func _set_up_player(player:Player, player_data:Dictionary, is_opponent:bool) ->Player:
	
	player.isOpponent = is_opponent
	player.has_ball = player_data["has_ball"]
	player.metadata["is_on_sideboard"] = player_data["is_on_sideboard"]
	player.metadata["coordinate_data"] = Vector2(player_data["grid_coordinate"][0],player_data["grid_coordinate"][1])

	for skill in player_data["skills"].keys():
		skill = int(skill)
		player.get_node("Skills").set_skill(skill, player_data["skills"][str(skill)])

	return player
		
func _load_puzzle_information(puzzle_data:PuzzleData, puzzle:PuzzleBase):
	puzzle.ui.get_node("%DescriptionLabel").text = puzzle_data.get_description()
	
