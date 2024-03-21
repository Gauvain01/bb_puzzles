class_name PuzzleData
extends Object

var _game_version: String 
var _puzzle_name: String
var _creator_name: String
var _puzzle_description:String
var _puzzle_type: int  #ENUM
var _player_team_type: int  #ENUM
var _opponent_team_type: int  #ENUM
var _player_team: Array  #Array[Player] containing position data
var _opponent_team: Array  # Array[Player] containing position data
var _is_ball_on_field: bool
var _ball_position: Array


func set_game_version(game_version: String):
	_game_version = game_version



func get_game_version() -> float:
	return float(_game_version)

func set_description(description:String):
	_puzzle_description = description

func get_description() -> String:
	return _puzzle_description


func set_puzzle_name(puzzle_name: String):
	_puzzle_name = puzzle_name


func get_puzzle_name() -> String:
	return _puzzle_name


func set_creator_name(creator_name: String):
	_creator_name = creator_name


func get_creator_name() -> String:
	return _creator_name


func set_puzzle_type(puzzle_type):
	_puzzle_type = puzzle_type


func get_puzzle_type() -> int:
	return _puzzle_type


func set_player_team_type(player_team_type: int):
	_player_team_type = player_team_type


func get_player_team_type() -> int:
	return _player_team_type


func set_opponent_team_type(opponent_team_type: int):
	_opponent_team_type = opponent_team_type


func get_opponent_team_type() -> int:
	return _opponent_team_type


func set_player_team(player_team: Array):
	var	_team_arr = []
	for player:Player in player_team:
		_team_arr.append(_wrap_player_object(player))

	_player_team = _team_arr

func _wrap_player_object(player:Player) -> Dictionary:
	var output = {}
	output["type"] = player.player_type_string
	output["skills"] = player.get_node("Skills").get_skill_map()
	output["stats"] = player.stats.to_dict()

	#check if player has ball
	if NodeInspector.get_ball_holdable_component(player).has_ball():
		output["has_ball"] = true
	else:
		output["has_ball"] = false
	#check if player is on sideboard
	if player.my_field_square.zone == "sideboard":
		output["is_on_sideboard"] = true
	else:
		output["is_on_sideboard"] = false
	
	var grid_arr = [
		player.my_field_square.gridCoordinate.x,
		player.my_field_square.gridCoordinate.y
		]
	output["grid_coordinate"] = grid_arr

	return output

func get_player_team() -> Array:
	return _player_team


func set_opponent_team(opponent_team: Array):
	var	_team_arr = []
	for player:Player in opponent_team:
		_team_arr.append(_wrap_player_object(player))

	_opponent_team = _team_arr

func get_opponent_team() -> Array:
	return _opponent_team


func set_is_ball_on_field(ball_on_field: bool):
	_is_ball_on_field = ball_on_field


func is_ball_on_field() -> bool:
	return _is_ball_on_field


func set_ball_position(ball_position: Vector2):
	_ball_position = [ball_position.x, ball_position.y]



func get_ball_position() -> Array:
	return _ball_position


class PuzzleDataParser extends Object:
	
	static func stringify_to_json(puzzle_data:PuzzleData) -> String:
		var output = {}	
		output["game_version"] = str(puzzle_data.get_game_version())
		output["puzzle_name"] = puzzle_data.get_puzzle_name()
		output["creator_name"] = puzzle_data.get_creator_name()
		output["puzzle_description"] = puzzle_data.get_description()
		output["puzzle_type"] = puzzle_data.get_puzzle_type() 
		output["opponent_team_type"] = puzzle_data.get_opponent_team_type()
		output["player_team_type"] = puzzle_data.get_player_team_type()
		output["player_team"] = puzzle_data.get_player_team()
		output["opponent_team"] = puzzle_data.get_opponent_team()
		output["is_ball_on_field"] = puzzle_data.is_ball_on_field()
		output["ball_position"] = puzzle_data.get_ball_position()
		
		return JSON.stringify(output)


	static func parse_from_json(puzzle_data_json:String) -> PuzzleData:
		var data:PuzzleData = PuzzleData.new()
		var input_dict = JSON.parse_string(puzzle_data_json)

		assert(input_dict != null, "failed parsing json")

		data.set_game_version(input_dict["game_version"])
		data.set_puzzle_name(input_dict["puzzle_name"])
		data.set_creator_name(input_dict["creator_name"])
		data.set_description(input_dict["puzzle_description"])
		data.set_puzzle_type(input_dict["puzzle_type"])
		data.set_opponent_team_type(input_dict["opponent_team_type"])
		data.set_player_team_type(input_dict["player_team_type"])
		data.set_player_team(input_dict["player_team"])
		data.set_opponent_team(input_dict["opponent_team"])
		data.set_is_ball_on_field(input_dict["is_ball_on_field"])
		data.set_ball_position(Vector2(input_dict["ball_position"][0], input_dict["ball_position"][1]))
		
		return data
		
		
		
		

