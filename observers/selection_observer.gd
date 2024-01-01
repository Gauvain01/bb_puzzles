class_name SelectionObserver
extends Node2D

@export var field: Field
@export var game_controller: GameController
@export var ui_controller: UiController

@onready var player_team: TeamComponent = field.player_team
@onready var side_board:SideBoard = get_node("%SideBoard")
@onready var grid: Node2D = field.grid
@onready var opponent_team: TeamComponent = field.opponent

var PlayerList = []
var selected_player: Player = null
var game_state = GAME_STATE.SETUP
var selected_field_square = null
var is_player_drag_and_drop = false
var is_select_coloration = true
var is_hover_allowed = true
var is_action_menu_active = false
signal _player_selected
signal hover_square(square)
signal hover_left(square)
signal selection_is_on
signal selection_is_off
signal request_to_place_on_field(board_piece, fieldSquare)


func _ready():
#	input_component.mouseClick.connect(on_mouse_click)
	for square in field.get_field_squares():
		NodeInspector.get_select_component(square).get_mouse_enter_signal().connect(
			on_mouse_enter_square
		)
		NodeInspector.get_select_component(square).get_mouse_exited_signal().connect(
			on_mouse_exit_square
		)
	#for player in player_team.get_players():
	#	PlayerList.append(player)
	#	player.ui_component.action_menu_component.is_activated.connect(
	#		on_action_menu_player_activated
	#	)
	#	player.ui_component.action_menu_component.is_deactivated.connect(
	#		on_action_menu_player_deactivated
	#	)

	#if game_state == GAME_STATE.SETUP:
	#	for i in player_team.get_players():
	#		i.select_component.selected.connect(on_player_select)
	#		var j: Player = i
	#		j.select_component.get_mouse_enter_signal().connect(on_mouse_enter_player)
	#		j.select_component.get_mouse_exited_signal().connect(on_mouse_exit_player)
	#	if game_controller.opponent_placement_allowed:
	#		for i in opponent_team.get_players():
	#			i.select_component.selected.connect(on_player_select)
	#			var j: Player = i
	#			j.select_component.get_mouse_enter_signal().connect(on_mouse_enter_player)
	#			j.select_component.get_mouse_exited_signal().connect(on_mouse_exit_player)
	for player:Player in player_team.get_players():
		player.state_machine.switched_states.connect(on_player_state_changed)
	start_listening_for_selected_field_square()

func start_listening_for_selected_field_square():
	for field_square:field_square_script.FieldSquare in field.grid.field_squares:
		if !field_square.select_component._mouse_entered_release_selected.is_connected(on_mouse_enter_square):
			field_square.select_component._mouse_entered_release_selected.connect(on_mouse_enter_square)
		if !field_square.select_component._mouse_exited_release_selected.is_connected(on_mouse_exit_square):
			field_square.select_component._mouse_exited_release_selected.connect(on_mouse_exit_square)

func stop_listening_for_selected_field_square():
	for field_square:field_square_script.FieldSquare in field.grid.field_squares:
		if field_square.select_component._mouse_entered_release_selected.is_connected(on_mouse_enter_square):
			field_square.select_component._mouse_entered_release_selected.disconnect(on_mouse_enter_square)
		if field_square.select_component._mouse_exited_release_selected.is_connected(on_mouse_exit_square):
			field_square.select_component._mouse_exited_release_selected.disconnect(on_mouse_exit_square)




func on_player_state_changed(_player:Player, new_state):
	match new_state:
		PLAYER_STATE.SETUP_STATE:
			#on selected player follows mouse
			listen_for_select_on_player(_player)
			#when deselected drops player on board and snaps on the correct field square
			if !_player_selected.is_connected(on_selected_player_for_drag_and_drop):
				_player_selected.connect(on_selected_player_for_drag_and_drop)
		PLAYER_STATE.IDLE_STATE:
			stop_listen_for_select_on_player(_player)

func stop_listen_for_select_on_player(_player):
	if _player.select_component.selected.is_connected(on_player_select_for_setting_selected_player):
		_player.select_component.selected.disconnect(on_player_select_for_setting_selected_player)
	
func listen_for_select_on_player(_player:Player):
	if !_player.select_component.selected.is_connected(on_player_select_for_setting_selected_player):
		_player.select_component.selected.connect(on_player_select_for_setting_selected_player)

func on_player_select_for_setting_selected_player(_player:Player):
	selected_player = _player
	for player:Player in player_team.get_players():
		player.select_component.selected.disconnect(on_player_select_for_setting_selected_player)
	
	_player_selected.emit()

func on_selected_player_for_drag_and_drop():
	is_player_drag_and_drop = true
	for player:Player in player_team.get_players():
		if player != selected_player:
			player.state_machine.switch_state(PLAYER_STATE.IDLE_STATE)
	selected_player.select_component.emit_deselected_on_next_mouse_release = true
	selected_player.select_component.listen_for_deselect()
	selected_player.select_component.deselected.connect(on_player_deselect_snap_player_to_field)
	selected_player.collider_component.area_shape_entered.connect(listen_for_field_square_from_player_collision)
	
func listen_for_field_square_from_player_collision(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if area.get_parent() is field_square_script.FieldSquare:
		selected_field_square = area.get_parent()


	

func set_player_pos_to_mouse_pos(_player:Player):
	var _mouse_position = get_viewport().get_mouse_position()
	_player.global_position = _mouse_position

func on_player_deselect_snap_player_to_field(_player:Player):
	if not field.is_mouse_inside_field():
		LogController.add_text("ERROR: MUST PLACE PLAYER ON FIELD OR SIDEBOARD DURING SETUP")
		side_board.request_to_place_on_sideBoard(_player)
	else:
		field.request_to_place_on_field(_player, selected_field_square)
	_player.select_component.deselected.disconnect(on_player_deselect_snap_player_to_field)
	_player.select_component.emit_deselected_on_next_mouse_release = false
	is_player_drag_and_drop = false

	for player:Player in player_team.get_players():
		player.state_machine.switch_state(PLAYER_STATE.SETUP_STATE)
	
	listen_for_select_on_player(_player)
	if !_player_selected.is_connected(on_selected_player_for_drag_and_drop):
		_player_selected.connect(on_selected_player_for_drag_and_drop)


func activate_hover_square(square: field_square_script.FieldSquare, isActive: bool):
	if !is_select_coloration:
		return
	if isActive:
		square.change_color(Color.AQUA)
	else:
		square.color_to_default()


func on_mouse_enter_square(square):
	hover_square.emit(square)
	activate_hover_square(square, true)


func on_mouse_exit_square(square):
	hover_left.emit(square)
	activate_hover_square(square, false)

#do not use mouse enter, use colliders.



func _process(_delta):
	if is_player_drag_and_drop:
		set_player_pos_to_mouse_pos(selected_player)

