class_name Ball
extends Node2D

var _ball_owner: BallHoldableComponent = null
var _collider_component: ColliderComponent
var _drag_drop_comp:DragAndDropComponent
signal ball_switched_owners(old_owner: BallHoldableComponent, new_owner: BallHoldableComponent)
var _previous_collided_owner:BallHoldableComponent
var _field:Field
var _is_suspended:bool = false

static func new_ball(field:Field) -> Ball:
	var __pckscn = preload("res://teams/ball.tscn")
	var ball:Ball = __pckscn.instantiate()
	ball.name = "Ball"
	ball._field = field
	return ball
	


func _ready():
	_collider_component = NodeInspector.get_collider_component(self)
	_collider_component.area_shape_entered.connect(on_shape_collided)
	_drag_drop_comp = NodeInspector.get_drag_and_drop_component(self)
	_drag_drop_comp.dropped_node.connect(on_drop_ball)
	_drag_drop_comp.dragging_node.connect(on_drag_ball)

func on_drag_ball():
	if _ball_owner != null:
		if _ball_owner.is_locked():
			return
		var ball = _ball_owner.release_ball()

		_ball_owner = null
	#just give it to the field
		_field.add_child(ball)
	_is_suspended = true

func on_drop_ball():
	if _ball_owner == null:

		if _previous_collided_owner.get_parent() is field_square_script.FieldSquare:
			var _sqr:field_square_script.FieldSquare = _previous_collided_owner.get_parent()

			if _sqr.is_occupied():
				_ball_owner = NodeInspector.get_ball_holdable_component(_sqr.get_occupied())
				_ball_owner.set_ball(self)
				_ball_owner.lock()
				return

		if _previous_collided_owner.get_parent() is Player:
			_previous_collided_owner.lock()

		_previous_collided_owner.set_ball(self)
		_ball_owner = _previous_collided_owner
	else:
		if _ball_owner.is_locked():
			return
		_switch_ball_owner(_previous_collided_owner)
	_is_suspended = false
	
	

func on_shape_collided(_reduntant, area: Area2D, _reduntant1, _reduntant2):
	if NodeInspector.has_ball_holdable_component(area.get_parent()):
		_previous_collided_owner = NodeInspector.get_ball_holdable_component(area.get_parent())
		if _is_suspended:
			return
		if _ball_owner == null:
			return
		var _colliding_owner = NodeInspector.get_ball_holdable_component(area.get_parent())
		if _colliding_owner == _ball_owner:
			return
		if _ball_owner.is_locked():
			return
		_switch_ball_owner(_colliding_owner)

func _switch_ball_owner(new_owner: BallHoldableComponent):
	if _ball_owner != null:
		new_owner.set_ball(_ball_owner.release_ball())
		if new_owner.get_parent() is Player:
			new_owner.lock()
		ball_switched_owners.emit(_ball_owner, new_owner)
		set_ball_owner(new_owner)

func get_ball_owner() -> BallHoldableComponent:
	return _ball_owner

func set_ball_owner(ball_owner: BallHoldableComponent):
	if _ball_owner == null and _ball_owner != ball_owner:
		ball_owner.set_ball(self)
		_ball_owner = ball_owner

func force_nullify_ball_owner():
	if _ball_owner != null:
		_ball_owner.release_ball()
	_ball_owner = null
