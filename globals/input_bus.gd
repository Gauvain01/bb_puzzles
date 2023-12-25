extends Node

signal spacePressed
signal mouseClick
signal mouseRelease
signal rightMouseClick

var SUBSCRIBED_NODES = {}; #{node_ref: [{"signal":signal_ref, "callable":callable_ref},...]}




func _input(event):
	if event is InputEventKey:
		if event.key_label == KEY_SPACE and event.is_pressed():
			spacePressed.emit()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			mouseClick.emit(event.global_position)
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			mouseRelease.emit()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			rightMouseClick.emit()


func unsubscribe_from_all(callable:Callable):
	_unsubscribe_from_signal_array(spacePressed.get_connections(), callable)
	_unsubscribe_from_signal_array(mouseClick.get_connections(), callable)
	_unsubscribe_from_signal_array(mouseRelease.get_connections(),callable)
	_unsubscribe_from_signal_array(rightMouseClick.get_connections(),callable)
		
func is_signal_connected_to_callable(node_to_observe:Node, signal_ref:Signal, callable:Callable) -> bool:
	if !SUBSCRIBED_NODES.has(node_to_observe):
		return false
	if len(SUBSCRIBED_NODES[node_to_observe]) == 0:
		return false
	
	for signal_callable_map in SUBSCRIBED_NODES[node_to_observe]:
		if signal_callable_map["signal"] == signal_ref:
			if signal_callable_map["callable"] == callable:
				return true
	return false
func _unsubscribe_from_signal_array(signal_array:Array, callable:Callable)->void:

	for sig_dic:Dictionary in signal_array:
		var sig:Signal =sig_dic["signal"]
		var sig_call:Callable = sig_dic["callable"]
		if callable == sig_call:
			sig.disconnect(sig_call)


func _append_subscribed_node_to_signal(observing_node:Node, signal_ref:Signal, callable:Callable):
	if SUBSCRIBED_NODES.has(observing_node):
		var signal_arr =SUBSCRIBED_NODES[observing_node]
		signal_arr.append({"signal":signal_ref, "callable":callable})
		return

	SUBSCRIBED_NODES[observing_node] = ([{"signal":signal_ref, "callable":callable}])
	
func disconnect_all_from_node(node:Node):
	if !SUBSCRIBED_NODES.has(node):
		return
	if len(SUBSCRIBED_NODES[node]) == 0:
		return
	for signal_callable_map in SUBSCRIBED_NODES[node]:
		signal_callable_map["signal"].disconnect(signal_callable_map["callable"])
	SUBSCRIBED_NODES[node] = []

func unsubscribe_from_signal(observing_node:Node, signal_ref:Signal):
	if !SUBSCRIBED_NODES.has(observing_node):
		return
	if len(SUBSCRIBED_NODES[observing_node]) == 0:
		return
	for signal_callable_map in SUBSCRIBED_NODES[observing_node]:
		if signal_callable_map["signal"] == signal_ref:
			signal_callable_map["signal"].disconnect(signal_callable_map["callable"])

func subscribe_to_signal(observing_node:Node, signal_ref:Signal, callable:Callable):
	_append_subscribed_node_to_signal(observing_node, signal_ref, callable)
	signal_ref.connect(callable)
func subscribe_to_mouse_click_event(observing_node:Node, callable:Callable):
	subscribe_to_signal(observing_node, mouseClick, callable)

func subscribe_to_mouse_release_event(observing_node:Node, callable:Callable):
	subscribe_to_signal(observing_node, mouseRelease, callable)

func subscribe_to_space_pressed_event(observing_node:Node, callable:Callable):
	subscribe_to_signal(observing_node, spacePressed, callable)

func subscribe_to_right_mouse_click_event(observing_node:Node, callable:Callable):
	subscribe_to_signal(observing_node, mouseClick, callable)







