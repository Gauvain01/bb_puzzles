class_name SelectionObserver
extends Node2D

@export var field: Field
@export var free_placement: bool = false
@onready var player_team: TeamComponent = field.player_team
@onready var side_board: SideBoardController = field.sideboard
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
	if field is PuzzleBuilderField:
		var player_builder = field.get_node("PlayerBuilder")
		player_builder.spawned_building_player.connect(on_new_player_spawn)
		
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
	for player: Player in player_team.get_players():
		player.state_machine.switched_states.connect(on_player_state_changed)
	for player: Player in opponent_team.get_players():
		player.state_machine.switched_states.connect(on_player_state_changed)

func on_new_player_spawn(_player: Player):
	if _player.state_machine.current_state == null:
		return
	if _player.state_machine.get_current_state_enum() == PLAYER_STATE.SETUP_STATE:
		listen_for_select_on_player(_player)

func start_listening_for_selected_field_square():
	for field_square: field_square_script.FieldSquare in field.grid.field_squares:
		if !field_square.select_component._mouse_entered_release_selected.is_connected(on_mouse_enter_square):
			field_square.select_component._mouse_entered_release_selected.connect(on_mouse_enter_square)
		if !field_square.select_component._mouse_exited_release_selected.is_connected(on_mouse_exit_square):
			field_square.select_component._mouse_exited_release_selected.connect(on_mouse_exit_square)

func stop_listening_for_selected_field_square():
	for field_square: field_square_script.FieldSquare in field.grid.field_squares:
		if field_square.select_component._mouse_entered_release_selected.is_connected(on_mouse_enter_square):
			field_square.select_component._mouse_entered_release_selected.disconnect(on_mouse_enter_square)
		if field_square.select_component._mouse_exited_release_selected.is_connected(on_mouse_exit_square):
			field_square.select_component._mouse_exited_release_selected.disconnect(on_mouse_exit_square)

func on_player_state_changed(_player: Player, new_state):
	match new_state:
		PLAYER_STATE.SETUP_STATE:
			#on selected player follows mouse
			listen_for_select_on_player(_player)
			#when deselected drops player on board and snaps on the correct field square
			if !_player_selected.is_connected(on_selected_player_for_drag_and_drop):
				_player_selected.connect(on_selected_player_for_drag_and_drop)
		PLAYER_STATE.IDLE_STATE:
			stop_listen_for_select_on_player(_player)
		PLAYER_STATE.ACTIVE_STATE:
			stop_listen_for_select_on_player(_player)

func stop_listen_for_select_on_player(_player):
	if _player.select_component.selected.is_connected(on_player_select_for_setting_selected_player):
		_player.select_component.selected.disconnect(on_player_select_for_setting_selected_player)
	
func listen_for_select_on_player(_player: Player):
	if !_player.select_component.selected.is_connected(on_player_select_for_setting_selected_player):
		_player.select_component.selected.connect(on_player_select_for_setting_selected_player)

func on_player_select_for_setting_selected_player(_player: Player):
	selected_player = _player
	_player_selected.emit()

func on_selected_player_for_drag_and_drop():
	is_player_drag_and_drop = true
	selected_player.select_component.emit_deselected_on_next_mouse_release = true
	selected_player.select_component.listen_for_deselect()
	selected_player.select_component.deselected.connect(on_player_deselect_drop_player)
	selected_player.collider_component.area_shape_entered.connect(listen_for_field_square_from_player_collision)
	NodeInspector.get_drag_and_drop_component(selected_player).drag()
	
func listen_for_field_square_from_player_collision(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int):
	if area.get_parent() is field_square_script.FieldSquare:
		selected_field_square = area.get_parent()

func set_player_pos_to_mouse_pos(_player: Player):
	var _mouse_position = get_viewport().get_mouse_position()
	_player.global_position = _mouse_position

func on_player_deselect_drop_player(_player: Player):
	NodeInspector.get_drag_and_drop_component(_player).drop()
	on_dropped_selected_player_for_field_placement()

	_player.select_component.deselected.disconnect(on_player_deselect_drop_player)
	_player.select_component.emit_deselected_on_next_mouse_release = false

func on_dropped_selected_player_for_field_placement():
	if not field.is_mouse_inside_field():
		LogController.add_text("ERROR: MUST PLACE PLAYER ON FIELD OR SIDEBOARD DURING SETUP")
		side_board.request_to_place_on_sideboard(selected_player)
	else:
		if free_placement:
			field.request_to_place_on_field(selected_player, selected_field_square)
		elif selected_field_square.get_player_team() != "opponent" and not selected_player.isOpponent:
			field.request_to_place_on_field(selected_player, selected_field_square)
		elif selected_field_square.get_player_team() == "opponent" and not selected_player.isOpponent:
			LogController.add_text("ERROR: placing on opponent's half not allowed")
			side_board.request_to_place_on_sideboard(selected_player)
		
	listen_for_select_on_player(selected_player)
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
