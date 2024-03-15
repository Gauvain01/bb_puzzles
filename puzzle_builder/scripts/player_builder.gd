class_name PlayerBuilder
extends Node2D

var player_builder_panel: PlayerBuilderPanel
@onready var field: PuzzleBuilderField = get_parent()
@onready var player_loader: PlayerLoader = get_node("%PlayerLoader")
var puzzle_builder_ui_controller: PuzzleBuilderUiController
# Called when the node enters the scene tree for the first time.

var _id_player_select_collection = {}
var _current_team_enum: int
var _current_player: Player
var _spawn_position: Vector2

signal spawned_building_player(player: Player)
signal despawned_building_player()

func set_up_player_builder():
	if field.ui.is_node_ready():
		player_builder_panel = field.ui.player_builder_panel
		puzzle_builder_ui_controller = field.ui
	else:
		await field.ui.ready
		puzzle_builder_ui_controller = field.ui
		player_builder_panel = field.ui.player_builder_panel

	set_up_team_signals()
	puzzle_builder_ui_controller = field.ui

func set_up_team_signals():
	puzzle_builder_ui_controller.player_team_selected.connect(on_player_team_selected)

func on_player_team_selected(team_enum):
	print("selected a player team")
	if _current_team_enum != null:
		reset_player_builder()

	#load player_team
	_current_team_enum = team_enum
	var team_collection = player_loader.load_player_collection(team_enum)

	#feed players into player_select
	for player: Player in team_collection:
		var id = player_builder_panel.player_select_dropdown.add_player(player.player_type_string)
		_id_player_select_collection[id] = player.player_type_string

	player_builder_panel.player_select_dropdown.get_popup().id_pressed.connect(on_player_select_id_pressed)
	#setup_player_select_signals

func on_player_select_id_pressed(id: int):
	#remove_current_player if existss
	despawn_building_player_if_exists()
	#find corresponding player_type
	var player_type_string = _id_player_select_collection[id]
	#load player instance
	var player: Player = player_loader.load_player_by_player_type(_current_team_enum, player_type_string)
	#spawn_player
	add_child(player)
	_current_player = player
	_current_player.global_position = player_builder_panel.place_holder_player.global_position + Vector2(35 / 2, 35 / 2)
	#set correct stats in builder panel
	load_player_stats_in_builder_panel(player)
	#check if opponent is checked
	check_for_opponent_check_and_apply_to_player(player)
	player.state_machine.switch_state(PLAYER_STATE.SETUP_STATE)
	spawned_building_player.emit(_current_player)

	start_listening_for_building_signals()


func check_for_opponent_check_and_apply_to_player(player: Player):
	if player_builder_panel.is_opponent_check_button.button_pressed:
		player.isOpponent = true
		player.mySprite.is_opponent = true
		player.mySprite.queue_redraw()
	else:
		player.isOpponent = false
		player.mySprite.is_opponent = false
		player.mySprite.queue_redraw()

func load_player_stats_in_builder_panel(player: Player):
	player_builder_panel.st_stat_controller.set_stat(player.stats.STR)
	player_builder_panel.av_stat_controller.set_stat(player.stats.AV)
	player_builder_panel.pa_stat_controller.set_stat(player.stats.PA)
	player_builder_panel.ag_stat_controller.set_stat(player.stats.AG)
	player_builder_panel.ma_stat_controller.set_stat(player.stats.MA)
	
func despawn_building_player_if_exists():
	if _current_player == null:
		return
	remove_child(_current_player)
	stop_listening_for_building_signals()
	_current_player = null
	despawned_building_player.emit()

func start_listening_for_building_signals():
	#connect opponent check button
	player_builder_panel.is_opponent_check_button.toggled.connect(on_opponent_check_button)
	#connect clear button
	player_builder_panel.clear_button.pressed.connect(on_clear_button_pressed)
	#connect to skill buttons when implemented
	player_builder_panel.block_check_button.toggled.connect(func(x):_current_player.skills.set_skill(SKILL_TYPE.BLOCK, x))
	player_builder_panel.guard_check_button.toggled.connect(func(x):_current_player.skills.set_skill(SKILL_TYPE.GUARD, x))
	player_builder_panel.stand_firm_check_button.toggled.connect(func(x):_current_player.skills.set_skill(SKILL_TYPE.STAND_FIRM, x))
	player_builder_panel.dodge_check_button.toggled.connect(func(x):_current_player.skills.set_skill(SKILL_TYPE.DODGE, x))
	player_builder_panel.frenzy_check_button.toggled.connect(func(x):_current_player.skills.set_skill(SKILL_TYPE.FRENZY, x))

	NodeInspector.get_drag_and_drop_component(_current_player).dragging_node.connect(on_player_drag)

func on_ball_button_toggled(is_toggled: bool):
	if is_toggled:
		if _current_player.has_ball:
			return
		_current_player.has_ball = true
		_current_player.ball_texture.show()
	else:
		if !_current_player.has_ball:
			return
		_current_player.has_ball = false
		_current_player.ball_texture.hide()

func on_clear_button_pressed():
	if _current_player == null:
		return
	load_player_stats_in_builder_panel(_current_player)

func on_opponent_check_button(pressed: bool):
	_current_player.isOpponent = pressed
	_current_player.mySprite.is_opponent = pressed
	_current_player.mySprite.queue_redraw()

func stop_listening_for_building_signals():
	if player_builder_panel.is_opponent_check_button.toggled.is_connected(on_opponent_check_button):
		player_builder_panel.is_opponent_check_button.toggled.disconnect(on_opponent_check_button)
	if _current_player == null:
		return
	Util.clear_callables_from_signal(player_builder_panel.block_check_button, player_builder_panel.block_check_button.toggled)
	Util.clear_callables_from_signal(player_builder_panel.dodge_check_button, player_builder_panel.dodge_check_button.toggled)
	Util.clear_callables_from_signal(player_builder_panel.frenzy_check_button, player_builder_panel.frenzy_check_button.toggled)
	Util.clear_callables_from_signal(player_builder_panel.stand_firm_check_button, player_builder_panel.stand_firm_check_button.toggled)
	Util.clear_callables_from_signal(player_builder_panel.guard_check_button, player_builder_panel.guard_check_button.toggled)
	

	

	var player_dd:DragAndDropComponent = NodeInspector.get_drag_and_drop_component(_current_player)
	if player_dd.dragging_node.is_connected(on_player_drag):
		player_dd.dragging_node.disconnect(on_player_drag)
		
	

func reset_player_builder():
	despawn_building_player_if_exists()

func on_player_drag():
	var ui = field.ui
	var av_stat_controller = ui.player_builder_panel.av_stat_controller
	var pa_stat_controller = ui.player_builder_panel.pa_stat_controller
	var str_stat_controller = ui.player_builder_panel.st_stat_controller 
	var ag_stat_controller = ui.player_builder_panel.ag_stat_controller
	var ma_stat_controller = ui.player_builder_panel.ma_stat_controller
	
	_current_player.stats.AV = av_stat_controller.get_current_stat_value() 
	_current_player.stats.PA = pa_stat_controller.get_current_stat_value()
	_current_player.stats.STR = str_stat_controller.get_current_stat_value()
	_current_player.stats.AG = ag_stat_controller.get_current_stat_value()
	_current_player.stats.MA = ma_stat_controller.get_current_stat_value()
	
	#set the correct node hierarchy
	remove_child(_current_player)
	if _current_player.isOpponent:
		field.opponent.add_child(_current_player)
	else:
		field.player_team.add_child(_current_player)

	reset_player_builder()
	
	
	
	








