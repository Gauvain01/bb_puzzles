class_name DragAndDropComponent
extends Node2D

var node_to_drag_and_drop:Node = null
var _callback_for_after_drop:Callable
signal dragging_node

func _ready():
	set_process(false)

func drag():
	set_process(true)
	node_to_drag_and_drop = get_parent()
	dragging_node.emit()
	
func drop(call_back:Callable):
	node_to_drag_and_drop = null
	_callback_for_after_drop = call_back


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if node_to_drag_and_drop != null:
		node_to_drag_and_drop.global_position = get_global_mouse_position()
	else:
		_callback_for_after_drop.call()
		set_process(false)



