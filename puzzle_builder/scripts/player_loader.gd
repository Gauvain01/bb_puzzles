class_name PlayerLoader
extends Node

var TEAM_NAME = {
	TEAM_ENUM.SKAVEN: "skaven",
	TEAM_ENUM.HUMANS: "humans",
}

func open_team_dir_get_player_path(team_enum: int) -> Array:
	
	var output := []
	var team_name = TEAM_NAME[team_enum]
	var dir_str = "res://teams/" + team_name + "/players"
	var dir = DirAccess.open(dir_str)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			output.append(dir_str + "/" + file_name)
			file_name = dir.get_next()
	else:
		assert(false)
	return output

func load_player_collection(team_enum: int) -> Array:
	var output = []
	var player_path = open_team_dir_get_player_path(team_enum)
	for path: String in player_path:
		var player = load(path).instantiate() as Player
		output.append(player)
	return output

func build_team(players: Array) -> TeamComponent:
	var team = load("res://components/component_scenes/team_component.tscn").instantiate() as TeamComponent
	for player in players:
		team.add_child(player)
	return team

func build_team_all_players_single_item(team_enum: int) -> TeamComponent:
	var players = load_player_collection(team_enum)
	return build_team(players)

func load_player_by_player_type(team_enum: int, player_type_string: String):
	var team_name = TEAM_NAME[team_enum]
	var dir_str = "res://teams/" + team_name + "/players"
	var dir = DirAccess.open(dir_str)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name == player_type_string + ".tscn":
				var path = dir_str + "/" + file_name
				var player = load(path).instantiate() as Player
				return player
			file_name = dir.get_next()
	else:
		assert(false)
		
func build_team_from_recipe(recipe):
	pass
