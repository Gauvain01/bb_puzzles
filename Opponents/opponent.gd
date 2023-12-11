extends Node2D

class_name OpponentTeamComponent
@export var gameController:Control
@export var field:Node2D
@export var inputManager:Node2D
@export var grid:Node2D
@export var util:Node2D
var game_state = GAME_STATE.SETUP
var players = []
func _ready():
	
	place_PlayerTeam_on_field()
	gameController.game_state_changed.connect(on_game_state_changed)
	for i in get_children():
		players.append(i)
		
func get_players() -> Array:
	if len(players) == 0:
		for i in get_children():
			players.append(i)
	return players

func place_PlayerTeam_on_field():
	for player in get_children():
		player.mySprite.set_modulate(Color.RED)
		
		field.request_to_place_opponent(player, player.myGridPosition)
		
	
	
	

func on_game_state_changed(new_game_state):
	game_state = new_game_state
	
func write_position_data():
	var player_data_container = []
	for i in get_children():
		var player:Player = i
		var player_data = {}
		player_data["node_name"] = player.name
		player_data["x_position"] = player.my_field_square.gridCoordinate.x
		player_data["y_position"] = player.my_field_square.gridCoordinate.y
		player_data_container.append(player_data)
	var json_string = JSON.stringify(player_data_container)
	
	var path = "res://save_games/"+ gameController.level_name + ".json"
	print(path)
	var acces_obj = FileAccess.open(path, FileAccess.WRITE_READ)
	print(json_string)
	acces_obj.store_line(json_string)
	
