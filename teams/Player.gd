extends Node2D
class_name Player

var player_team
var type
var stats

@export var mySprite: Sprite2D
@export var myCollider: Area2D
@export var myGridPosition: Vector2
@export var isOpponent: bool = false
@export var ball_texture: TextureRect
var select_component: SelectComponent
@export var ui_component: PlayerUiComponent
@export var actionMenu: MenuButton
@export var blockDiceViewer: BlockDiceViewer
@export var select_color = Color.ORANGE
@export var hover_color = Color.BLUE
var player_state
var my_field_square: field_square_script.FieldSquare
var util

@export var has_ball = false
@export var isMarked: bool = false

signal selectionSignal(thisObject)
signal on_mouse_entered(thisObject)
signal on_mouse_exited(thisObject)

signal request_move_event
signal request_block_event
signal request_blitz_event

signal deactivated_player

signal removed_select_component(select_component: SelectComponent)
signal added_new_select_component(select_component: SelectComponent)

var isActive: bool = true

var is_blitz_available: bool = true
signal game_state_change(game_state)

var game_state = GAME_STATE.SETUP

var default_color = "#ffffff"


func relay_my_select_component_signal(_node):
	selectionSignal.emit(self)


func change_color(color: Color):
	mySprite.set_modulate(color)


func return_to_default_color():
	mySprite.set_modulate(default_color)


func end_turn():
	mySprite.set_modulate(Color.GRAY)
	isActive = false
	ui_component.activate_ui_component(false)


func show_menu():
	actionMenu.show_popup()


func get_my_field_square():
	return my_field_square

func disable():
	select_component.disable()

func _ready():
	stats = get_node("Stats")
	mySprite = get_node("BoardSprite")
	select_component = get_node("Select_Component")
	select_component.node_emit_on_select = self
	select_component.is_listen_for_deselect = true
	mySprite.is_opponent = isOpponent
	mySprite.draw_team_overlay()

	if has_ball:
		ball_texture.visible = true


func give_ball():
	has_ball = true
	ball_texture.visible = true


func on_game_state_change(game_state_new):
	self.game_state = game_state
	if game_state_new == GAME_STATE.PLAY:
		on_game_state_play()
	return


func on_game_state_play():
	pass


func change_player_state(player_state):
	on_player_state_changed(player_state)


func on_player_state_changed(player_state):
	if self.player_state == PLAYER_STATE.INACTIVE_STATE:
		return
	if self.player_state == player_state:
		return

	self.player_state = player_state

	if player_state == PLAYER_STATE.ACTIVE_STATE:
		on_active_player_state()
		return

	if player_state == PLAYER_STATE.INACTIVE_STATE:
		deactivate()
		return


func on_active_player_state():
	listen_for_click_and_select()
	set_player_action_menu_signals()
	ui_component.activate_ui_component(true)


func listen_for_click_and_select():
	select_component.visible = true


func activate_menu_for_player_state():
	if player_state == PLAYER_STATE.ACTIVE_STATE:
		return ui_component.activate_action_menu(true)
	return null


func set_player_action_menu_signals():
	ui_component.action_menu_component.get_move_signal().connect(on_move_action, CONNECT_ONE_SHOT)
	ui_component.action_menu_component.get_block_signal().connect(on_block_action, CONNECT_ONE_SHOT)
	ui_component.action_menu_component.get_end_action_signal().connect(
		on_end_action, CONNECT_ONE_SHOT
	)

	if is_blitz_available:
		ui_component.action_menu_component.get_blitz_signal().connect(
			on_blitz_action, CONNECT_ONE_SHOT
		)
	else:
		ui_component.action_menu_component.blitz_button.disabled = true
	print(ui_component.action_menu_component.get_blitz_signal().get_connections())


func on_move_action():
	request_move_event.emit(self)
	ui_component.action_menu_component.deactivate()


func on_block_action():
	request_block_event.emit(self)
	ui_component.action_menu_component.deactivate()


func on_blitz_action():
	print("blitz pressed")
	request_blitz_event.emit(self)
	ui_component.action_menu_component.deactivate()


func on_end_action():
	change_player_state(PLAYER_STATE.INACTIVE_STATE)
	deactivated_player.emit()
	ui_component.action_menu_component.deactivate()


func on_disable_collision(is_disabled):
	select_component.collision_component.disabled = is_disabled


func deactivate():
	isActive = false
	default_color = Color.GRAY
	return_to_default_color()
	ui_component.activate_ui_component(false)


func activate_select_component():
	if NodeInspector.has_select_component(self):
		return
	ComponentFactory.build_select_component()


func on_game_state_setup():
	select_component.selected.connect(on_player_selected_during_setup, CONNECT_ONE_SHOT)

func on_player_selected_during_setup(_redundant):
	change_color(select_color)
	select_component.deselected.connect(on_deselect_during_setup)

func on_deselect_during_setup(_redundant):
	change_color(default_color)
	select_component.selected.connect(on_player_selected_during_setup, CONNECT_ONE_SHOT)
	;;
	
func setup_select_color_activation():
	select_component.selected.connect(_on_player_selected, CONNECT_ONE_SHOT)

func _on_player_selected(_redundant):
	change_color(select_color)
	select_component.deselected.connect(_on_player_deselected)

func _on_player_deselected(_redundant):
	change_color(default_color)
	select_component.selected.connect(_on_player_selected, CONNECT_ONE_SHOT)

func setup_hover_color_activation():
	select_component.mouse_entered.connect(on_mouse_entered_for_hover, CONNECT_ONE_SHOT)

func on_mouse_entered_for_hover():
	change_color(hover_color)
	select_component.mouse_exited.connect(on_mouse_exited_for_hover, CONNECT_ONE_SHOT)

func on_mouse_exited_for_hover():
	change_color(default_color)
	setup_hover_color_activation()

func stop_select_color_activation():
	pass

func stop_hover_color_activation():
	pass	