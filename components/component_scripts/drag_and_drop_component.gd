class_name DragAndDropComponent
extends Node2D

var node_to_drag_and_drop:Node = null
signal dragging_node
signal dropped_node

func _ready():
	set_process(false)

func drag():
	set_process(true)
	node_to_drag_and_drop = get_parent()
	dragging_node.emit()
	node_to_drag_and_drop.z_index += 100
	
func drop():
	node_to_drag_and_drop.z_index -= 100

	node_to_drag_and_drop = null
	dropped_node.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if node_to_drag_and_drop != null:
		node_to_drag_and_drop.global_position = get_global_mouse_position()
	else:
		set_process(false)



