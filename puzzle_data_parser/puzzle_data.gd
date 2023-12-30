class_name PuzzleData
extends Object

var _game_version: int
var _puzzle_name: String
var _creator_name: String
var _puzzle_type: int  #ENUM
var _player_team_type: int  #ENUM
var _opponent_team_type: int  #ENUM
var _player_team: Array  #Array[Player] containing position data
var _opponent_team: Array  # Array[Player] containing position data
var _is_ball_on_field: bool
var _ball_position: Vector2


func set_game_version(game_version: int):
	_game_version = game_version


func get_game_version() -> int:
	return _game_version


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
	_player_team = player_team


func get_player_team() -> Array:
	return _player_team


func set_opponent_team(opponent_team: Array):
	_opponent_team = opponent_team


func get_opponent_team() -> Array:
	return _opponent_team


func set_is_ball_on_field(ball_on_field: bool):
	_is_ball_on_field = ball_on_field


func is_ball_on_field() -> bool:
	return _is_ball_on_field


func set_ball_position(ball_position: Vector2):
	_ball_position = ball_position


func get_ball_position() -> Vector2:
	return _ball_position




	
