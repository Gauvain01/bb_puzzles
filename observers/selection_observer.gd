class_name SelectionObserver
extends Node2D

@export var field: Field
@export var game_controller: GameController
@export var ui_controller: UiController

@onready var player_team: TeamComponent = field.player_team
@onready var sideboard: PanelContainer = ui_controller.sideboard
@onready var grid: Node2D = field.grid
@onready var opponent_team: TeamComponent = field.opponent

var PlayerList = []
var selected_player: Player = null
var game_state = GAME_STATE.SETUP
var selected_field_square = null

var is_select_coloration = true
var is_hover_allowed = true
var is_action_menu_active = false

signal hover_square(square)
signal hover_left(square)
signal selection_is_on
signal selection_is_off
signal request_to_place_on_field(board_piece, fieldSquare)


func on_game_state_changed(new_game_state):
	if game_state == GAME_STATE.SETUP and new_game_state == GAME_STATE.PLAY:
		for i in player_team.get_players():
			var player: Player = i
			player.change_player_state(PLAYER_STATE.ACTIVE_STATE)
			player.select_component.selected.disconnect(on_player_select)
			player.select_component.selected.connect(on_player_select_during_play)
		for i in opponent_team.get_players():
			i.select_component.selected.disconnect(on_player_select)
		for square in field.get_field_squares():
			NodeInspector.get_select_component(square).mouse_release.disconnect(on_mouse_release)
	if new_game_state == GAME_STATE.COMPLETE:
		pass
	game_state = new_game_state


func _ready():
#	input_component.mouseClick.connect(on_mouse_click)
	for square in field.get_field_squares():
		NodeInspector.get_select_component(square).mouse_release.connect(on_mouse_release)
		NodeInspector.get_select_component(square).get_mouse_enter_signal().connect(
			on_mouse_enter_square
		)
		NodeInspector.get_select_component(square).get_mouse_exited_signal().connect(
			on_mouse_exit_square
		)
	game_controller.game_state_changed.connect(on_game_state_changed)

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

func on_player_state_changed(new_state):
	match new_state:
		PLAYER_STATE.SETUP_STATE:
			pass	
		PLAYER_STATE.ACTIVE_STATE:
			pass
		_:
			pass
		


func on_action_menu_player_activated():
	player_team.disable_select_component_for_players(true)


func on_action_menu_player_deactivated():
	player_team.disable_select_component_for_players(false)


func activate_select_coloration(isActive):
	is_select_coloration = isActive


func activate_hover_player(player: Player, isActive: bool):
	if isActive:
		player.change_color(Color.AQUA)
	else:
		player.return_to_default_color()


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


func on_mouse_enter_player(player):
	activate_hover_player(player, true)


func on_mouse_exit_player(player):
	activate_hover_player(player, false)


func _process(_delta):
	if selected_player != null:
		selected_player.global_position = get_viewport().get_mouse_position()


func on_mouse_release(field_square):
	if selected_player != null:
		selected_field_square = field_square
		if field.isOnTheField(get_viewport().get_mouse_position()):
			if selected_player.my_field_square.zone == "sideboard":
				sideboard.players_on_sideboard -= 1

			field.request_to_place_on_field(selected_player, selected_field_square)

			#selectedPlayer[0].global_position = mouseInFieldSquare.global_position
		#print(mouseInFieldSquare)
		if selected_field_square.zone == "sideboard":
			if selected_player.my_field_square.zone != "sideboard":
				if selected_field_square.occupied == null:
					sideboard.players_on_sideboard += 1
			field.request_to_place_on_field(selected_player, selected_field_square)

		selected_player.mySprite.change_to_unselect_color()
		selected_player = null
		selection_is_off.emit()


func on_player_select(player: Player):
	selected_player = player
	selected_field_square = player.my_field_square
	if game_state == GAME_STATE.SETUP:
		player.mySprite.change_to_select_color()
	selection_is_on.emit()


func on_player_select_during_play(player: Player):
	player_team.activate_action_menu_for_player(player)

