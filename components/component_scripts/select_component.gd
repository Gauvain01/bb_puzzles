extends Area2D

class_name SelectComponent
@export var node_emit_on_select:Node2D
var collision_component:CollisionShape2D
var input_Component:InputComponent
signal selected
signal mouse_release
signal _mouse_entered_release_selected
signal _mouse_exited_release_selected
# Called when the node enters the scene tree for the first time.


func disable():
	input_Component.mouseClick.disconnect(on_mouse_click_selector)
	input_Component.mouseRelease.disconnect(on_mouse_release_selector)
	node_emit_on_select = null
	Util.clear_callables_from_signals_in_node(self)
	get_parent().remove_child(self)

func enable():
	if node_emit_on_select == null:
		node_emit_on_select = get_parent()
	_ready()


func _ready():
	collision_component = get_node("CollisionShape2D")
	input_Component = get_node("InputComponent")
	input_Component.mouseClick.connect(on_mouse_click_selector)
	input_Component.mouseRelease.connect(on_mouse_release_selector)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	_mouse_entered_release_selected.emit(node_emit_on_select)

func _on_mouse_exited():
	_mouse_exited_release_selected.emit(node_emit_on_select)

func is_mouse_in_collider() -> bool:
	var point = get_viewport().get_mouse_position()
	var pos = global_position
	var SQUARE_SIZE = self.collision_component.shape.get_rect().size * scale
	var x = point.x
	var y = point.y
	
	if x >= (pos.x - (SQUARE_SIZE.x/2)) and x <= (pos.x + (SQUARE_SIZE.x/2)):
		if y >= (pos.y - (SQUARE_SIZE.y/2)) and y <= (pos.y + (SQUARE_SIZE.y/2)):
			return true
		else:
			return false
	else:
		return false

func on_mouse_click_selector(_redundant):
	if is_mouse_in_collider():
		
		selected.emit(node_emit_on_select)
		

func on_mouse_release_selector():
	
	if is_mouse_in_collider():
		mouse_release.emit(node_emit_on_select)

func set_shape_collider(shape:Shape2D):
	collision_component.shape = shape


func get_mouse_enter_signal() -> Signal:
	return _mouse_entered_release_selected

func get_mouse_exited_signal() ->Signal:
	return _mouse_exited_release_selected
