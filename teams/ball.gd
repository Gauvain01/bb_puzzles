class_name Ball
extends Node2D

var _ball_owner: BallHoldableComponent = null
var _collider_component: ColliderComponent
var _drag_drop_comp:DragAndDropComponent
signal ball_switched_owners(old_owner: BallHoldableComponent, new_owner: BallHoldableComponent)
var _previous_collided_owner:BallHoldableComponent

func _ready():
	_collider_component = NodeInspector.get_collider_component(self)
	_collider_component.area_shape_entered.connect(on_shape_collided)
	_drag_drop_comp = NodeInspector.get_drag_and_drop_component(self)
	_drag_drop_comp.dropped_node.connect(on_drop_ball)

func on_drop_ball():
	var ball_ref:Ball
	if _ball_owner == null:
		ball_ref = self
	else:
		ball_ref = _ball_owner.release_ball()
		
	_previous_collided_owner.set_ball(ball_ref)
	

func on_shape_collided(_reduntant, area: Area2D, _reduntant1, _reduntant2):
	if NodeInspector.has_ball_holdable_component(area.get_parent()):
		_previous_collided_owner = NodeInspector.get_ball_holdable_component(area.get_parent())
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
	_ball_owner = ball_owner

func force_nullify_ball_owner():
	if _ball_owner != null:
		_ball_owner.release_ball()
	_ball_owner = null
