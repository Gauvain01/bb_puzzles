extends Node

const SELECT_COMPONENT_NAME = "SelectComponent"
const BLOCK_MENU_COMPONENT_NAME = "BlockMenuComponent"
const COLLIDER_COMPONENT_NAME = "ColliderComponent"
const FOLLOW_STAY_COMPONENT_NAME = "FollowStayMenuComponent"
const INPUT_COMPONENT_NAME = "InputComponent"
const LOG_ACCES_COMPONENT_NAME = "LogAccesComponent"
const PLAYER_UI_COMPONENT_NAME = "PlayerUiComponent"
const ROLL_DISPLAY_COMPONENT_NAME = "RollDisplayComponent"
const DRAG_AND_DROP_COMPONENT_NAME = "DragAndDropComponent"
const BALL_HOLDABLE_COMPONENT_NAME = "BallHoldableComponent"

var stored_component_references = {} # {generic_component_name_string:component_ref}

func has_ball_holdable_component(node_to_inspect: Node) -> bool:
	var node_or_null = node_to_inspect.get_node_or_null(BALL_HOLDABLE_COMPONENT_NAME)
	if node_or_null == null:
		return false
	return true

func get_ball_holdable_component(node_to_inspect: Node) -> BallHoldableComponent:
	return node_to_inspect.get_node(BALL_HOLDABLE_COMPONENT_NAME)

func has_select_component(node_to_inspect: Node) -> bool:
	var node_or_null = node_to_inspect.get_node_or_null(SELECT_COMPONENT_NAME)
	if node_or_null == null:
		return false
	
	return true

func get_select_component(node_to_inspect: Node) -> SelectComponent:
	return node_to_inspect.get_node(SELECT_COMPONENT_NAME)

## Checks if node_to_inspect contains a reference to desired component
## otherwise a get_node call is made and a custom reference to said component is stored inside node_to_inspect for future calls
## function asserts false if node_to_inspect does not contain desired component
func _get_component_assert_false_if_null(node_to_inspect: Node, component_name: String):
	var stored_reference_name = str(node_to_inspect) + component_name
	if stored_component_references.has(stored_reference_name):
		return stored_component_references[stored_reference_name]
	else:
		var _component = node_to_inspect.get_node_or_null(component_name)
		assert(_component != null, str(node_to_inspect) + " contains no component of type " + component_name)
		stored_component_references[stored_reference_name] = _component
		return _component

func get_block_menu_component(node_to_inpsect: Node) -> BlockMenuComponent:
	return _get_component_assert_false_if_null(node_to_inpsect, BLOCK_MENU_COMPONENT_NAME)

func get_collider_component(node_to_inspect: Node) -> ColliderComponent:
	return _get_component_assert_false_if_null(node_to_inspect, COLLIDER_COMPONENT_NAME)

func get_follow_stay_menu_component(node_to_inspect: Node) -> FollowStayMenuComponent:
	return _get_component_assert_false_if_null(node_to_inspect, FOLLOW_STAY_COMPONENT_NAME)

func get_input_component(node_to_inspect: Node) -> InputComponent:
	return _get_component_assert_false_if_null(node_to_inspect, INPUT_COMPONENT_NAME)

func get_log_acces_component(node_to_inspect: Node) -> Node2D:
	return _get_component_assert_false_if_null(node_to_inspect, LOG_ACCES_COMPONENT_NAME)

func get_player_ui_component(node_to_inspect: Node) -> PlayerUiComponent:
	return _get_component_assert_false_if_null(node_to_inspect, PLAYER_UI_COMPONENT_NAME)

func get_roll_display_component(node_to_inspect: Node) -> RollDisplayComponent:
	return _get_component_assert_false_if_null(node_to_inspect, ROLL_DISPLAY_COMPONENT_NAME)

func get_drag_and_drop_component(node_to_inspect: Node) -> DragAndDropComponent:
	return _get_component_assert_false_if_null(node_to_inspect, DRAG_AND_DROP_COMPONENT_NAME)
