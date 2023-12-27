class_name TeamComponent
extends Node2D

@export var ui_controller:UiController
@export var gameController:GameController
@export var grid:Node2D
@export var is_opponent:bool = false

@onready var sideboard:PanelContainer = ui_controller.sideboard

var game_state = GAME_STATE.SETUP
var players:Array[Player] = []

signal _disable_select_component_for_all_players(is_disabled:bool)



func change_color_all_players(color:Color = Color.WHITE) -> void:
	
	for player in get_players():
		player.default_color = color
		player.change_color(color)


func activate_action_menu_for_player(player:Player):
	
	
	player.ui_component.activate_action_menu(true)
	

	
func _ready():
	
	gameController.game_state_changed.connect(on_game_state_changed)
	
	for i in get_children():
		var player:Player = i
		players.append(player)
		_disable_select_component_for_all_players.connect(player.on_disable_collision)

func disable_select_component_for_players(is_disable:bool):
	_disable_select_component_for_all_players.emit(is_disable)

func activate_ui_component_all_players(isActive:bool, exception:Player = null):
	for player in get_children():
		var i:Player = player

		if player == exception:
			continue

		if isActive:
			disable_select_component_for_players(false)
			if i.player_state == PLAYER_STATE.ACTIVE_STATE:
				i.ui_component.activate_ui_component(isActive)
			if i.player_state == PLAYER_STATE.FINISHED_STATE:
				continue

		ComponentPool.store_select_component(i.select_component)


func get_players() -> Array[Player]:
	if len(players) == 0:
		for i in get_children():
			players.append(i)
	return players


func clear_player_ui():
	for i in get_players():
		var player:Player = i
		player.ui_component.clear_button_signals()


func place_PlayerTeam_on_sideboard():
	for player in get_children():
		sideboard.request_to_place_on_sideBoard(player)


func on_game_state_changed(new_game_state):
	game_state = new_game_state
	
	for i in get_players():
		i.game_state_change.emit(new_game_state)


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
		path = "res://team_setup_position_data/opponent/"+ gameController.level_name + ".json"
	else:
		path = "res://team_setup_position_data/user/"+ gameController.level_name + ".json"
		
	var acces_obj = FileAccess.open(path, FileAccess.WRITE_READ)
	acces_obj.store_line(json_string)
	acces_obj.close()

func get_position_data_from_file_node_name_pos_format() -> Dictionary:
	var output = {}

	var path
	if is_opponent:
		path = "res://team_setup_position_data/opponent/"+ gameController.level_name + ".json"
	else:
		path = "res://team_setup_position_data/user/"+ gameController.level_name + ".json"
	
	var acces_obj = FileAccess.open(path, FileAccess.READ)
	var json_string = acces_obj.get_as_text()
	var json_dict = JSON.parse_string(json_string)
	
	for i in json_dict:
		var node_name = i["node_name"]
		var pos = Vector2(i["x_position"], i["y_position"])
		output[node_name] = pos
	acces_obj.close()
	return output

		
func disable():
	for player:Player in get_players():
		player.disable()