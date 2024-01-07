extends Node2D
class_name PlayerUiComponent
var block_menu_component:BlockMenuComponent
var follow_stay_menu_component:FollowStayMenuComponent
var collider_component:ColliderComponent
var action_menu_component:ActionMenuComponent
var active_menu = null
var timer
var is_listen_for_mouse_click_active = false
signal is_deactivated
signal is_activated

func clear_button_signals():
	for i in [block_menu_component, follow_stay_menu_component, action_menu_component]:
		i.clear_button_signals()

func activate_ui_component(isActive):
	visible = isActive
	if !isActive:
		if active_menu != null:
			active_menu.deactivate()

func deactivate_active_menu():
	if active_menu != null:
		print("emiited_signal")
		active_menu.deactivate()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	block_menu_component = get_node("BlockMenuComponent")
	follow_stay_menu_component = get_node("FollowStayMenuComponent")
	collider_component = get_node("ColliderComponent")
	action_menu_component = get_node("ActionMenuComponent")

func _process(delta):
	global_position = get_parent().global_position

func _change_menu(menu, isActive:bool):
	if !visible:
		return
		
	if isActive:
		
		if active_menu != null:
			active_menu.deactivate()
		menu.activate()
		active_menu = menu
		collider_component.visible = true
		listen_for_mouse_click(true)
	else:
		if active_menu != null:
			active_menu.deactivate()
			active_menu = null
		collider_component.visible = false
		listen_for_mouse_click(false)

func activate_block_menu(isActive:bool):
	_change_menu(block_menu_component, isActive)
	

func activate_follow_stay_menu(isActive:bool):
	_change_menu(follow_stay_menu_component, isActive)

func activate_action_menu(isActive:bool):
	_change_menu(action_menu_component, isActive)
	
func on_mouse_click(_redundant):
	
	if active_menu == action_menu_component:
		
		if !collider_component.is_mouse_in_collider():
			active_menu.deactivate()
			is_deactivated.emit()
			active_menu = null
			InputBus.unsubscribe_from_signal(self, InputBus.mouseClick)
			is_listen_for_mouse_click_active = false
		
func listen_for_mouse_click(isActive:bool):
	if isActive:
		if !is_listen_for_mouse_click_active:
			InputBus.subscribe_to_mouse_click_event(self, on_mouse_click)
			is_listen_for_mouse_click_active = true

	else:
		if is_listen_for_mouse_click_active:
			InputBus.unsubscribe_from_signal(self, InputBus.mouseClick)
			is_listen_for_mouse_click_active = false

