extends Node



const SELECT_COMPONENT_NAME = "SelectComponent"
const BLOCK_MENU_COMPONENT_NAME = "BlockMenuComponent"
const COLLIDER_COMPONENT_NAME = "ColliderComponent"
const FOLLOW_STAY_COMPONENT_NAME = "FollowStayMenuComponent"
const INPUT_COMPONENT_NAME = "InputComponent"
const LOG_ACCES_COMPONENT_NAME = "LogAccesComponent"
const PLAYER_UI_COMPONENT_NAME = "PlayerUiComponent"
const ROLL_DISPLAY_COMPONENT_NAME = "RollDisplayComponent"




func has_select_component(node_to_inspect:Node) -> bool:
	var node_or_null = node_to_inspect.get_node_or_null(SELECT_COMPONENT_NAME)
	if node_or_null == null:
		return false
	
	return true

func get_select_component(node_to_inspect:Node) -> SelectComponent:
	return node_to_inspect.get_node(SELECT_COMPONENT_NAME)


func get_block_menu_component(node_to_inpsect:Node) -> BlockMenuComponent:
	return node_to_inpsect.get_node(BLOCK_MENU_COMPONENT_NAME)

func get_collider_component(node_to_inspect:Node) -> ColliderComponent:
	return node_to_inspect.get_node(COLLIDER_COMPONENT_NAME)

func get_follow_stay_menu_component(node_to_inspect:Node) -> FollowStayMenuComponent:
	return node_to_inspect.get_node(FOLLOW_STAY_COMPONENT_NAME)

func get_input_component(node_to_inspect:Node) -> InputComponent:
	return node_to_inspect.get_node(INPUT_COMPONENT_NAME)

func get_log_acces_component(node_to_inspect:Node) -> Node2D:
	return node_to_inspect.get_node(LOG_ACCES_COMPONENT_NAME)

func get_player_ui_component(node_to_inspect:Node) -> PlayerUiComponent:
	return node_to_inspect.get_node(PLAYER_UI_COMPONENT_NAME)

func get_roll_display_component(node_to_inspect:Node) -> RollDisplayComponent:
	return node_to_inspect.get_node(ROLL_DISPLAY_COMPONENT_NAME)

