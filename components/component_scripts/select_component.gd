extends Area2D

class_name SelectComponent
@export var node_emit_on_select: Node2D
var collision_component: CollisionShape2D
@export var allow_emit_deselected:bool = false
@export var emit_deselected_on_next_mouse_click:bool = false
@export var emit_deselected_on_next_mouse_release:bool = true
signal selected
signal deselected
signal mouse_release
signal _mouse_entered_release_selected
signal _mouse_exited_release_selected

var enabled_flag = true
var is_mouse_entered = false


func disable():
	enabled_flag = false
	InputBus.unsubscribe_from_signal(self, InputBus.mouseClick)
	InputBus.unsubscribe_from_signal(self, InputBus.mouseRelease)
	mouse_entered.disconnect(_on_mouse_entered)
	mouse_exited.disconnect(_on_mouse_exited)

func enable():
	enabled_flag = true
	_ready()


func _ready():
	collision_component = get_node("CollisionShape2D")
	InputBus.subscribe_to_mouse_click_event(self, on_mouse_click_selector)
	InputBus.subscribe_to_mouse_release_event(self, on_mouse_release_selector)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered():
	if !enabled_flag:
		return
	if not is_mouse_entered:
		_mouse_entered_release_selected.emit(node_emit_on_select)
		is_mouse_entered = true


func _on_mouse_exited():
	if !enabled_flag:
		return
	if not collision_component.shape.get_rect().has_point(get_local_mouse_position()):
		_mouse_exited_release_selected.emit(node_emit_on_select)
		is_mouse_entered = false


func is_mouse_in_collider() -> bool:
	return collision_component.shape.get_rect().has_point(get_local_mouse_position())


func on_mouse_click_selector(_redundant):
	if !enabled_flag:
		return

	if is_mouse_in_collider():
		selected.emit(node_emit_on_select)
		if allow_emit_deselected:
			listen_for_deselect()
			
func listen_for_deselect():
	if emit_deselected_on_next_mouse_release:
		InputBus.subscribe_to_mouse_release_event(self, _mouse_deselect)
		print("listening for deselect on " + str(self)) 
	#deselect_on_next_click?
	#deselect_on_next_release?
func _mouse_deselect():
	print("mouse deselected")
	deselected.emit(node_emit_on_select)


func on_mouse_release_selector():
	if !enabled_flag:
		return

	if is_mouse_in_collider():
		mouse_release.emit(node_emit_on_select)


func set_shape_collider(shape: Shape2D):
	collision_component.shape = shape


func get_mouse_enter_signal() -> Signal:
	return _mouse_entered_release_selected


func get_mouse_exited_signal() -> Signal:
	return _mouse_exited_release_selected
