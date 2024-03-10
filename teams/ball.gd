class_name Ball
extends Node2D

var _ball_owner: BallHoldableComponent = null
var _collider_component: ColliderComponent
signal ball_switched_owners(old_owner: BallHoldableComponent, new_owner: BallHoldableComponent)

func _ready():
	_collider_component = NodeInspector.get_collider_component(self)
	_collider_component.area_shape_entered.connect(on_shape_collided)

func on_shape_collided(_reduntant, area: Area2D, _reduntant1, _reduntant2):
	if NodeInspector.has_ball_holdable_component(area.get_parent()):
		var _colliding_owner = NodeInspector.get_ball_holdable_component(area.get_parent())
		if _colliding_owner == _ball_owner:
			return
		if _ball_owner.is_locked():
			return
		_switch_ball_owner(_colliding_owner)

func _switch_ball_owner(new_owner: BallHoldableComponent):
	if _ball_owner != null:
		new_owner.set_ball(_ball_owner.release_ball())
		ball_switched_owners.emit(_ball_owner, new_owner)
		set_ball_owner(new_owner)

func get_ball_owner() -> BallHoldableComponent:
	return _ball_owner

func set_ball_owner(ball_owner: BallHoldableComponent):
	if _ball_owner != null:
		LogController.add_text("ERROR: Ball Already owned, can't place Ball owner:{0}".format([ball_owner.get_parent()]))
		return
	_ball_owner = ball_owner

func force_nullify_ball_owner():
	if _ball_owner != null:
		_ball_owner.release_ball()
	_ball_owner = null
