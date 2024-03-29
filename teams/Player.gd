class_name Player
extends Node2D

var player_team
var type
var stats: PlayerStats


@export var player_type_string: String
@export var mySprite: PlayerSprite
@export var myCollider: Area2D
@export var myGridPosition: Vector2
@export var isOpponent: bool = false
@export var ball_texture: TextureRect
@export var collider_component: ColliderComponent
@export var ui_component: PlayerUiComponent
@export var actionMenu: MenuButton
@export var blockDiceViewer: BlockDiceViewer
@export var select_color = Color.ORANGE
@export var hover_color = Color.BLUE
@export var blitz_color = Color.GREEN
@export var block_color = Color.PURPLE
@export var team_type:int
@onready var skills:Skills = get_node("Skills")
var select_component: SelectComponent

var ball_holdable_component: BallHoldableComponent

var player_state
var my_field_square: field_square_script.FieldSquare
var util

@export var has_ball = false
@export var isMarked: bool = false

var state_machine: PlayerStateMachine = null

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

func _ready():
	stats = get_node("Stats")
	mySprite = get_node("BoardSprite")
	select_component = NodeInspector.get_select_component(self)
	select_component.node_emit_on_select = self
	select_component.allow_emit_deselected = true

	mySprite.is_opponent = isOpponent
	mySprite.draw_team_overlay()
	state_machine = PlayerStateMachine.new()
	add_child(state_machine)
	state_machine.setup_state_machine(self)
	ball_holdable_component = NodeInspector.get_ball_holdable_component(self)

	if has_ball:
		ball_texture.visible = true

func give_ball():
	has_ball = true
	ball_texture.visible = true

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

func unset_player_action_menu_signals():
	var menu_comp = ui_component.action_menu_component
	if menu_comp.get_move_signal().is_connected(on_move_action):
		menu_comp.get_move_signal().disconnect(on_move_action)
	if menu_comp.get_block_signal().is_connected(on_block_action):
		menu_comp.get_block_signal().disconnect(on_block_action)
	if menu_comp.get_end_action_signal().is_connected(on_end_action):
		menu_comp.get_end_action_signal().disconnect(on_end_action)
	if menu_comp.get_blitz_signal().is_connected(on_blitz_action):
		menu_comp.get_blitz_signal().disconnect(on_blitz_action)
	
func deactivate_action_menu():
	unset_player_action_menu_signals()
	ui_component.deactivate_active_menu()
	ui_component.show_menu(false)

func on_move_action():
	state_machine.switch_state(PLAYER_STATE.MOVE_STATE)
	request_move_event.emit(self)
	ui_component.action_menu_component.deactivate()

func on_block_action():
	state_machine.switch_state(PLAYER_STATE.BLOCK_STATE)
	request_block_event.emit(self)
	ui_component.action_menu_component.deactivate()

func on_blitz_action():
	state_machine.switch_state(PLAYER_STATE.BLITZ_STATE)
	request_blitz_event.emit(self)
	ui_component.action_menu_component.deactivate()

func on_end_action():
	state_machine.switch_state(PLAYER_STATE.FINISHED_STATE)
	ui_component.action_menu_component.deactivate()

func deactivate():
	isActive = false
	default_color = Color.GRAY
	return_to_default_color()
	ui_component.activate_ui_component(false)

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
	print("hovered")
	change_color(hover_color)
	select_component.mouse_exited.connect(on_mouse_exited_for_hover, CONNECT_ONE_SHOT)

func on_mouse_exited_for_hover():
	change_color(default_color)
	setup_hover_color_activation()

func stop_select_color_activation():
	if select_component.selected.is_connected(_on_player_selected):
		select_component.selected.disconnect(_on_player_selected)
	if select_component.deselected.is_connected(_on_player_deselected):
		select_component.deselected.disconnect(_on_player_deselected)

func stop_hover_color_activation():
	if select_component.mouse_entered.is_connected(on_mouse_entered_for_hover):
		select_component.mouse_entered.disconnect(on_mouse_entered_for_hover)
	if select_component.mouse_exited.is_connected(on_mouse_exited_for_hover):
		select_component.mouse_exited.disconnect(on_mouse_exited_for_hover)

func setup_action_menu_for_activation():
	set_player_action_menu_signals()
	ui_component.activate_action_menu(true)
		
func move_player(square: field_square_script.FieldSquare):
	#check incoming if square is empty
	if square.is_occupied():
		#do nothing
		LogController.add_text("Tried To move player but selected square is occupied")
		return
	#check player occupation
	if my_field_square != null:
		my_field_square.occupy_set_null()
	
	square.occupy(self)
	position = square.position
