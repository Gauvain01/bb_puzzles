extends Node

#why no interfaces, polymorfism, abstract classes, multiple inheritance.........

const _ACTION_MENU_COMPONENT_PATH = "res://components/component_scenes/action_menu_component.tscn"
const _BLOCK_MENU_COMPONENT_PATH = "res://components/component_scenes/block_menu_component.tscn"
const _COLLIDER_COMPONENT_PATH ="res://components/component_scenes/collider_component.tscn"
const _FOLLOW_STAY_MENU_COMPONENT_PATH ="res://components/component_scenes/follow_stay_menu_component.tscn"  
const _INPUT_COMPONENT_PATH ="res://components/component_scenes/input_component.tscn"  
const _PLAYER_UI_COMPONENT_PATH ="res://components/component_scenes/player_ui_component.tscn"
const _ROLL_DISPLAY_COMPONENT_PATH ="res://components/component_scenes/roll_display_component.tscn"
const _SELECT_COMPONENT_PATH ="res://components/component_scenes/select_component.tscn"

var _COMPONENT_ENUM_MAP = {
	COMPONENT_TYPE.ACTION_MENU_COMPONENT:Callable(self, "build_action_menu_component"),
	COMPONENT_TYPE.BLOCK_MENU_COMPONENT:Callable(self, "build_block_menu_component"),
	COMPONENT_TYPE.COLLIDER_COMPONENT:Callable(self, "build_collider_component"),
	COMPONENT_TYPE.FOLLOW_STAY_MENU_COMPONENT:Callable(self, "build_follow_stay_menu_component"),
	COMPONENT_TYPE.INPUT_COMPONENT:Callable(self, "build_input_component"),
	COMPONENT_TYPE.PLAYER_UI_COMPONENT:Callable(self, "build_player_ui_component"),
	COMPONENT_TYPE.ROLL_DISPLAY_COMPONENT:Callable(self, "build_roll_display_component"),
	COMPONENT_TYPE.SELECT_COMPONENT:Callable(self, "build_select_component"),
		}

func build_component_by_component_type(component_type:int) -> Node:
	var cal:Callable = _COMPONENT_ENUM_MAP[component_type]
	return cal.call()

func build_action_menu_component() -> ActionMenuComponent:
	return preload(_ACTION_MENU_COMPONENT_PATH).instantiate()

func build_block_menu_component() -> BlockMenuComponent:
	return preload(_BLOCK_MENU_COMPONENT_PATH ).instaniate()

func build_collider_component() -> ColliderComponent:
	return preload(_COLLIDER_COMPONENT_PATH ).instantiate()

func build_follow_stay_menu_component() -> FollowStayMenuComponent:
	return preload(_FOLLOW_STAY_MENU_COMPONENT_PATH ).instantiate()

func build_input_component() -> InputComponent:
	return preload(_INPUT_COMPONENT_PATH ).instantiate()

func build_player_ui_component() -> PlayerUiComponent:
	return preload(_PLAYER_UI_COMPONENT_PATH).instantiate()

func build_roll_display_component() -> RollDisplayComponent:
	return preload(_ROLL_DISPLAY_COMPONENT_PATH).instantiate()

func build_select_component() -> SelectComponent:
	return preload(_SELECT_COMPONENT_PATH).instantiate()

