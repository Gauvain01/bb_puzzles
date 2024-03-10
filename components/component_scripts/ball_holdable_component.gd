class_name BallHoldableComponent
extends Node

var _ball_container: Ball
var _locked: bool = false

func lock():
	_locked = true

func unlock():
	_locked = false

func is_locked():
	return _locked

func release_ball() -> Ball:
	_ball_container.get_parent().remove_child(_ball_container)
	var output = _ball_container
	_ball_container = null
	return output

func set_ball(ball: Ball):
	ball.get_parent().remove_child(ball)
	add_sibling(ball)
	_ball_container = ball

func get_ball(is_set_null=false):
	var output = _ball_container
	if is_set_null:
		_ball_container = null

	return output

func has_ball() -> bool:
	if _ball_container != null:
		return true
	return false
