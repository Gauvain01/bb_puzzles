class_name Ball
extends Node2D

var _ball_owner = null
var _grid_coordinate: Vector2

func get_ball_owner():
	return _ball_owner

func set_ball_owner(ball_owner):
	
	if ball_owner is Player:
		_grid_coordinate = ball_owner.my_field_square.gridCoordinate
	if ball_owner is field_square_script.FieldSquare:
		_grid_coordinate = ball_owner.gridCoordinate
	
	global_position = ball_owner.global_position

	_ball_owner = ball_owner

func get_grid_coordinate() -> Vector2:
	return _grid_coordinate

func move_ball_to_owner():
	global_position = _ball_owner.global_position
	if _ball_owner is Player:
		_grid_coordinate = _ball_owner.my_field_square.gridCoordinate
	if _ball_owner is field_square_script.FieldSquare:
		_grid_coordinate = _ball_owner.gridCoordinate

func set_grid_coordinate(grid_coordinate: Vector2):
	_grid_coordinate = grid_coordinate
