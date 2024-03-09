class_name BallHoldableComponent
extends Node

var _ball_container: Ball

signal got_ball_parent_on_emit(parent)

func set_ball(ball: Ball):
	_ball_container = ball
	got_ball_parent_on_emit.emit(get_parent())

func get_ball(is_set_null=false):
	var output = _ball_container
	if is_set_null:
		_ball_container = null

	return output

func has_ball() -> bool:
	if _ball_container != null:
		return true
	return false
