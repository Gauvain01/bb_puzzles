class_name TeamComponent
extends Node2D

@export var is_opponent:bool = false


var game_state = GAME_STATE.SETUP
var players:Array[Player] = []

signal _disable_select_component_for_all_players(is_disabled:bool)



func _ready():
	
	GameStateMachine.switched_game_state.connect(on_game_state_changed)
	if is_opponent:
		for player:Player in get_players():
			player.state_machine.switch_state(PLAYER_STATE.IDLE_STATE)
	
func disable_select_component_for_players(is_disable:bool):
	_disable_select_component_for_all_players.emit(is_disable)

func set_active_players_to_active_state():
	for player:Player in get_active_players():
		player.state_machine.switch_state(PLAYER_STATE.ACTIVE_STATE)
func set_all_active_players_to_idle_state():
	for player in get_active_players():
		player.state_machine.switch_state(PLAYER_STATE.IDLE_STATE)

func set_not_downed_players_to_target_select_state():
	for player:Player in get_active_players():
		player.state_machine.switch_state(PLAYER_STATE.TARGET_SELECT_STATE)

func get_active_players():

	var output = []
	for player:Player in get_players():
		if is_instance_of(player.state_machine.current_state, PlayerStateMachine.FinishedState) or is_instance_of(player.state_machine.current_state,PlayerStateMachine.DownedState):
			LogController.add_text("got here")
			
			continue
		else:
			output.append(player)
	return output

func get_players() -> Array[Player]:
	if len(players) == 0:
		for i in get_children():
			players.append(i)
	return players

func on_game_state_changed(new_game_state, old_game_state):
	
	if is_opponent:
		return
	
	match new_game_state:
		GAME_STATE.SETUP:
			for player in get_players():
				player.state_machine.switch_state(PLAYER_STATE.SETUP_STATE)
		GAME_STATE.PLAY:
			for player in get_players():
				player.state_machine.switch_state(PLAYER_STATE.ACTIVE_STATE)
				


func store_position_data():
	var player_data_container = []
	for i in get_children():
		var player:Player = i
		var player_data = {}
		player_data["node_name"] = player.name
		player_data["x_position"] = player.my_field_square.gridCoordinate.x
		player_data["y_position"] = player.my_field_square.gridCoordinate.y
		player_data_container.append(player_data)
	var json_string = JSON.stringify(player_data_container)

	var path
	if is_opponent:
		path = "res://team_setup_position_data/opponent/"+ "skaven one turn" + ".json"
	else:
		path = "res://team_setup_position_data/user/"+ "skaven one turn" + ".json"
		
	var acces_obj = FileAccess.open(path, FileAccess.WRITE_READ)
	acces_obj.store_line(json_string)
	acces_obj.close()

func get_position_data_from_file_node_name_pos_format() -> Dictionary:
	var output = {}

	var path
	if is_opponent:
		path = "res://team_setup_position_data/opponent/"+ "skaven one turn" + ".json"
	else:
		path = "res://team_setup_position_data/user/"+ "skaven one turn" + ".json"
	
	var acces_obj = FileAccess.open(path, FileAccess.READ)
	var json_string = acces_obj.get_as_text()
	var json_dict = JSON.parse_string(json_string)
	
	for i in json_dict:
		var node_name = i["node_name"]
		var pos = Vector2(i["x_position"], i["y_position"])
		output[node_name] = pos
	acces_obj.close()
	return output
