class_name TackleZoneComponent
extends Node2D

@export var grid:Node2D
@export var field:Node2D
@export var player_team:TeamComponent
@export var opponent:Node2D

var opponent_tackle_check_button:CheckButton
var player_team_tackle_check_button:CheckButton

var tacklezone_possible_coordinate_map = {}
var opponent_tackle_zone_map = {}
var active_player_tackle_zones = null
var active_opponent_tackle_zones = null
var is_PlayerTeam_button_checked = false
var is_opponent_button_checked = false


func refresh_tackle_zones():
	set_tackle_zones_squares_map()
	if is_opponent_button_checked:
		opponent_tackle_check_button.button_pressed = false
		opponent_tackle_check_button.button_pressed = true
		
	if is_PlayerTeam_button_checked:
		player_team_tackle_check_button.button_pressed = false
		player_team_tackle_check_button.button_pressed = true
		
func set_tackle_zones_squares_map():
	var dict = tacklezone_possible_coordinate_map.duplicate()
	for square in get_player_squares(opponent):
		var grid_coordinate = square.gridCoordinate
		var tz1 =[ Vector2(grid_coordinate.x -1, grid_coordinate.y +1),
			Vector2(grid_coordinate.x , grid_coordinate.y +1),
			Vector2(grid_coordinate.x + 1, grid_coordinate.y +1),
			Vector2(grid_coordinate.x +1, grid_coordinate.y),
			Vector2(grid_coordinate.x -1, grid_coordinate.y),
			Vector2(grid_coordinate.x -1, grid_coordinate.y -1),
			Vector2(grid_coordinate.x , grid_coordinate.y -1),
			Vector2(grid_coordinate.x + 1, grid_coordinate.y -1)]
		for coordinate in tz1:
			if coordinate.x >= 0 and coordinate.y >= 0:
				if coordinate.x < 15 and coordinate.y < 26:
					dict[coordinate] = dict[coordinate] + 1
	opponent_tackle_zone_map = dict
	
func connect_button_signals(opponent_check, player_team_check):
	opponent_tackle_check_button = opponent_check
	player_team_tackle_check_button = player_team_check
	player_team_tackle_check_button.toggled.connect(_on_tackle_zone_check_button_toggled)
	opponent_tackle_check_button.toggled.connect(_on_check_button_toggled)

func is_in_opponent_tackle_zone(gridCoordinate):
	var tackle_zones = []
	var tackle_zone_map = get_tackle_zone_squares(opponent)
	for i in tackle_zone_map:
		tackle_zones.append(i[0].gridCoordinate)
	return gridCoordinate in tackle_zones
	

func set_up_tackle_zones_component():
	create_tacklezone_possible_coordinate_map()
	tacklezone_possible_coordinate_map.duplicate()
func create_tacklezone_possible_coordinate_map():
	for x in range(grid.COLUMNS):
		for y in range(grid.ROWS):
			tacklezone_possible_coordinate_map[Vector2(x,y)] = 0
			
func get_tackle_zone_squares(player_team) -> Array:
	var dict = tacklezone_possible_coordinate_map.duplicate()
	var output = []
	for square in get_player_squares(player_team):
		if square.zone == "sideboard":
			continue
		var grid_coordinate = square.gridCoordinate
		var tz1 =[ Vector2(grid_coordinate.x -1, grid_coordinate.y +1),
			Vector2(grid_coordinate.x , grid_coordinate.y +1),
			Vector2(grid_coordinate.x + 1, grid_coordinate.y +1),
			Vector2(grid_coordinate.x +1, grid_coordinate.y),
			Vector2(grid_coordinate.x -1, grid_coordinate.y),
			Vector2(grid_coordinate.x -1, grid_coordinate.y -1),
			Vector2(grid_coordinate.x , grid_coordinate.y -1),
			Vector2(grid_coordinate.x + 1, grid_coordinate.y -1)]
		for coordinate in tz1:
			if coordinate.x >= 0 and coordinate.y >= 0:
				if coordinate.x < 15 and coordinate.y < 26:
					dict[coordinate] = dict[coordinate] + 1
	
	for key in dict.keys():
		var item = dict[key]
		if item > 0:
			output.append([field.player_coordinate_position_map[key],item])
	return output

## returns a dictionary containing all field coordinates as keys and tackle_zone_number as value
## {[Vector2]:[Int]}
func get_opponent_tackle_zone_squares_map() -> Dictionary:
	if len(opponent_tackle_zone_map) == 0:
		set_tackle_zones_squares_map()
	return opponent_tackle_zone_map
	
func color_tackle_zones(tackle_zones:Array, color:Color):
	
	var field_squares = tackle_zones
	for field_square in field_squares:
		if field_square[0].occupied == null:
			field_square[0].color = color
			field_square[0]._field_color = color
			field_square[0].default_color = color
			field_square[0].queue_redraw()
			field_square[0].activate_label(true,"%d" %field_square[1] )
			field_square[0].force_label = true
	
	
	
func get_player_squares(player_team):
	var squares = []
	for player in player_team.get_children():
		squares.append(player.my_field_square)
	return squares


func uncolor_tackle_zones(tackle_zones:Array):
	for data in tackle_zones:
		data[0].force_label = false
		data[0].activate_label(false)
		data[0].color = Color.OLIVE
		data[0]._field_color = Color.OLIVE
		data[0].default_color = Color.OLIVE
		data[0].queue_redraw()
	
	
func _on_tackle_zone_check_button_toggled(button_pressed):
	if button_pressed:
		if is_opponent_button_checked:
			_on_check_button_toggled(false)
			opponent_tackle_check_button.set_pressed_no_signal(false)
		is_PlayerTeam_button_checked = true
		active_player_tackle_zones = get_tackle_zone_squares(player_team)
		color_tackle_zones(get_tackle_zone_squares(player_team), Color.AQUA)
		
			
	else:
		is_PlayerTeam_button_checked = false
		uncolor_tackle_zones(active_player_tackle_zones)
		active_player_tackle_zones = null


func _on_check_button_toggled(button_pressed):
	if button_pressed:
		if is_PlayerTeam_button_checked:
			_on_tackle_zone_check_button_toggled(false)
			player_team_tackle_check_button.set_pressed_no_signal(false)
		is_opponent_button_checked = true
		active_opponent_tackle_zones = get_tackle_zone_squares(opponent)
		color_tackle_zones(get_tackle_zone_squares(opponent), Color.INDIAN_RED)
		
	else:
		is_opponent_button_checked = false
		if active_opponent_tackle_zones != null:
			uncolor_tackle_zones(active_opponent_tackle_zones)
			active_opponent_tackle_zones = null

