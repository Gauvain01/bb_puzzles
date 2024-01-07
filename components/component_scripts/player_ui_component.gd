extends Node2D
class_name PlayerUiComponent
var block_menu_component:BlockMenuComponent
var follow_stay_menu_component:FollowStayMenuComponent
var collider_component:ColliderComponent
var action_menu_component:ActionMenuComponent
var active_menu = null
var timer
var select_component:SelectComponent
var _callable_for_process = null
signal is_deactivated
signal is_activated

func clear_button_signals():
	for i in [block_menu_component, follow_stay_menu_component, action_menu_component]:
		i.clear_button_signals()

func show_menu(isActive):
	if !isActive:
		if active_menu != null:
			_schedule_show_menu(active_menu.deactivate)
		hide()
	else:
		show()
		if active_menu != null:
			_schedule_show_menu(active_menu.activate)


func deactivate_active_menu():
	if active_menu != null:
		active_menu.deactivate()
	stop_listen_for_mouse_click()

# Called when the node enters the scene tree for the first time.
func _ready():
	select_component = NodeInspector.get_select_component(get_parent())
	block_menu_component = get_node("BlockMenuComponent")
	follow_stay_menu_component = get_node("FollowStayMenuComponent")
	collider_component = get_node("ColliderComponent")
	action_menu_component = get_node("ActionMenuComponent")

func _process(delta):
	global_position = get_parent().global_position
	if _callable_for_process != null:
		_callable_for_process.call()
		_callable_for_process = null

func _change_menu(menu):
		if active_menu != null:
			active_menu.deactivate()
		active_menu = menu
		collider_component.visible = true

func activate_block_menu():
	_change_menu(block_menu_component)
	show_menu(true)

func activate_follow_stay_menu():
	_change_menu(follow_stay_menu_component)
	show_menu(true)


func set_active_menu_to_action_menu():
	active_menu = action_menu_component

func activate_action_menu(isActive:bool):
	_change_menu(action_menu_component)
	listen_for_mouse_click()
	
func on_mouse_click(_redundant):
	LogController.add_text("clicked")
	LogController.add_text(active_menu)
	if active_menu != null:
		show()
		show_menu(true)
		InputBus.subscribe_to_mouse_click_event(self, on_mouse_click_for_deactivation)	


func on_mouse_click_for_deactivation(_redundant):
	LogController.add_text("got_here")
	if !collider_component.is_mouse_in_collider():
		is_deactivated.emit()
		show_menu(false)
		listen_for_mouse_click()
		hide()
		InputBus.unsubscribe_from_signal(self, InputBus.mouseClick, on_mouse_click_for_deactivation)

func listen_for_mouse_click():
	LogController.add_text("listening_for_mouse_clicked")
	select_component.selected.connect(on_mouse_click, CONNECT_ONE_SHOT)

func stop_listen_for_mouse_click():
	if select_component.selected.is_connected(on_mouse_click):
		select_component.selected.disconnect(on_mouse_click)
	InputBus.disconnect_all_from_node(self)

func _schedule_show_menu(callable:Callable):
	_callable_for_process = callable
	


