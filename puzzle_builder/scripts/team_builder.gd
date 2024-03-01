class_name TeamBuilder
extends Node2D

@export var puzzle_builder_field: PuzzleBuilderField
@onready var ui: PuzzleBuilderUiController = get_node("%PuzzleBuilderUi")

var opponent_player_collection = {} # {team:TEAM_ENUM, players:{object_id:Player}}
var player_team_player_collection = {} # {team:TEAM_ENUM, players:{object_id:Player}}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	puzzle_builder_field.refreshed_opponent_team.connect(on_refreshed_opponent_team)
	puzzle_builder_field.refreshed_player_team.connect(on_refreshed_player_team)
	puzzle_builder_field.spawned_new_player.connect(on_new_player_spawn)

func on_refreshed_opponent_team():
	opponent_player_collection.clear()
	opponent_player_collection["team"] = ui.current_selected_opponent_team
	for player: Player in puzzle_builder_field.opponent.get_players():
		var player_id = player.get_instance_id()
		if !opponent_player_collection.has("players"):
			opponent_player_collection["players"] = {}

		opponent_player_collection["players"][player_id] = player

func on_refreshed_player_team():
	player_team_player_collection.clear()
	player_team_player_collection["team"] = ui.current_selected_player_team
	for player: Player in puzzle_builder_field.player_team.get_players():
		var player_id = player.get_instance_id()
		if !player_team_player_collection.has("players"):
			player_team_player_collection["players"] = {}

		player_team_player_collection["players"][player_id] = player

func on_new_player_spawn(player: Player):

	if player.isOpponent:
		if opponent_player_collection["players"].has(player.get_instance_id()):
			assert(false)
		opponent_player_collection["players"][player.get_instance_id()] = player
	else:
		if player_team_player_collection["players"].has(player.get_instance_id()):
			assert(false)
		player_team_player_collection["players"][player.get_instance_id()] = player
