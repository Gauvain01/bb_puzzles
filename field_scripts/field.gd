extends Node2D
class_name Field
@onready var sideboard: SideBoardController = get_node("SideBoardController")
@onready var grid: Node2D = get_node("grid")
@onready var player_team: TeamComponent = get_node("PlayerTeam")
@onready var tackle_zone_component: TackleZoneComponent = get_node("TackleZoneComponent")
@onready var opponent: TeamComponent = get_node("Opponent")
var field_rect: Rect2
var player_coordinate_position_map = {}
var field_squares_draw_array = []
var isDrawBox = true
var isFieldSquaresDraw = false
var isRedrawSingleSquare = false
var singleSquareToRedraw
var players_on_field = 0

var field_map = null
var _ball: Ball = null

signal moved_player_during_play(player_ref: Player)
signal moved_player(player_ref: Player, coord_from: Vector2, coord_to: Vector2)
signal mouse_release_on_field_square

signal placed_new_player_on_field(player, side_board_square)
signal placed_player_on_field(player)
func on_mouse_release_square_select(square):
	mouse_release_on_field_square.emit(square)

func setup_field_square_mouse_release_signal():
	for i in grid.field_squares:
		var square: field_square_script.FieldSquare = i
		var select_comp: SelectComponent = square.get_node("SelectComponent")
		select_comp.mouse_release.connect(on_mouse_release_square_select)

func get_field_map() -> Dictionary:
	if field_map == null:
		field_map = {}
		for i in grid.field_squares:
			field_map[i.gridCoordinate] = i
	return field_map

func get_not_obstacle_map() -> Dictionary:
	var field_map = get_field_map()

	var output = {}
	for key in field_map.keys():
		var is_not_obstacle = true
		if field_map[key].occupied != null:
			is_not_obstacle = false
		output[key] = is_not_obstacle

	return output

func move_player_to_coordinate(player: Player, coordinate: Vector2):
	var player_square = player.my_field_square
	var new_square = get_field_square_by_grid_position(coordinate)
	var old_square = player.my_field_square

	if new_square.occupied != null:
		assert(false, "cannot move player to occupied square, deal with occupied square first")

	if player_square != null:
		player_square.occupy_set_null()

	new_square.occupy(player)

	player.my_field_square = new_square
	player.global_position = new_square.global_position
	moved_player.emit(player, old_square, new_square.gridCoordinate)

	if GameStateMachine.get_game_state() == GAME_STATE.PLAY:
		moved_player_during_play.emit(player)

func remove_player_from_field(player: Player):
	var player_square = player.my_field_square
	player_square.occupied = null
	sideboard.request_to_place_on_sideboard(player)

func get_field_squares():
	return grid.field_squares

func get_field_square_by_grid_position(coordinate) -> field_square_script.FieldSquare:
	return player_coordinate_position_map[coordinate]

func get_field_squares_by_grid_positions(gridPositions: Array) -> Array:
	var output = []
	for coordinate in gridPositions:
		if coordinate.x >= 0 and coordinate.y >= 0:
			if coordinate.x < 15 and coordinate.y < 26:
				output.append(player_coordinate_position_map[coordinate])

	return output

func set_field_Squares_draw_flag():
	for field_square in grid.field_squares:
		field_squares_draw_array.append(
			[
				[field_square._get_square_position(), field_square._get_size()],
				field_square._get_color()
			]
		)
	isFieldSquaresDraw = true

	queue_redraw()

func set_redraw_single_square_flag(field_square):
	singleSquareToRedraw = field_square
	isRedrawSingleSquare = true
	queue_redraw()

func is_grid_coordinate_out_of_bounds(coordinate) -> bool:
	if coordinate.x >= 0 and coordinate.y >= 0:
		if coordinate.x < 15 and coordinate.y < 26:
			return false
	return true

func request_to_place_opponent(player, gridCoordinate):
	var field_square = player_coordinate_position_map[gridCoordinate]
	if player.my_field_square != null:
		player.my_field_square.disable_collision(false)

	player.my_field_square = field_square
	field_square.disable_collision(true)
	player.my_field_square.occupy(player)
	player.global_position = field_square.global_position
	placed_player_on_field.emit(player)
func _ready():
	set_z_index(1)
	grid.draw_field_squares.connect(set_field_Squares_draw_flag)
	grid.redraw_single_square.connect(set_redraw_single_square_flag)
	setup_field_square_mouse_release_signal()
	queue_redraw()
	field_rect = Rect2(
				grid.X_FILL,
				grid.Y_FILL,
				grid.COLUMNS * grid.SQUARE_SIZE,
				grid.ROWS * grid.SQUARE_SIZE
			)

	tackle_zone_component.set_up_tackle_zones_component()

func request_to_place_on_field(player: Player, requested_square: field_square_script.FieldSquare):
	print(" got called")
	var current_player_square = player.my_field_square

	if requested_square.get_occupied() != null and requested_square.get_occupied() is Player:
		_switch_players(player, requested_square.occupied)
		return
	if current_player_square != null:
		current_player_square.occupy_set_null()
	requested_square.occupy(player)
	placed_new_player_on_field.emit(player, current_player_square)
	placed_player_on_field.emit(player)

func _switch_players(player_one: Player, player_two: Player):
	var player_one_square = player_one.my_field_square
	var player_two_square = player_two.my_field_square

	player_one_square.occupy(player_two)
	player_two_square.occupy(player_one)

func _draw():
	if isDrawBox:
		draw_rect(
			Rect2(
				grid.X_FILL,
				grid.Y_FILL,
				grid.COLUMNS * grid.SQUARE_SIZE,
				grid.ROWS * grid.SQUARE_SIZE
			),
			Color.BLACK
		)

func isOnTheField(point: Vector2) -> bool:
	return field_rect.has_point(point)

func is_mouse_inside_field() -> bool:
	return isOnTheField(get_local_mouse_position())

func get_player_gridPositions(player_team):
	var squares = []
	for player in player_team.get_children():
		squares.append([player.my_field_square.gridCoordinate, player])
	return squares

func evaluate_possible_block_for_players():
	for player in player_team.get_active_players():
		if BlockChecker.evaluate_player_has_block_targets(player, self):
			player.ui_component.action_menu_component.block_button.disabled = false

func get_field_square_for_mouse_position(mouse_position: Vector2):
	for i in grid.field_squares:
		var square: field_square_script.FieldSquare = i

		var coordA
		var coordB
		var coordC
		var coordD
		var myPosition = square.global_position + Vector2(35 / 2, 35 / 2)
		var eventPosition = mouse_position

		coordA = Vector2(myPosition.x - square.size.x, myPosition.y - square.size.y)
		coordB = coordA + Vector2(square.size.x, 0)
		coordD = coordA + Vector2(0, square.size.y)
		coordC = Vector2(coordB.x, coordD.y)

		if Util.isInsideSquare(coordA, coordB, coordC, coordD, eventPosition):
			return square

func _on_game_controller_game_state_changed(game_state):
	if game_state == GAME_STATE.PLAY:
		evaluate_possible_block_for_players()
		tackle_zone_component.refresh_tackle_zones()

func reset_field_state():
	for i in grid.field_squares:
		var square: field_square_script.FieldSquare = i
		square.default_color = square._field_color

		square.color_to_default()
		square.activate_label(false)

func _on_save_button_toggled(button_pressed: bool):
	if button_pressed:
		opponent.store_position_data()
		player_team.store_position_data()

func place_opponent_team_on_field():
	var players = opponent.get_players()
	var position_data = opponent.get_position_data_from_file_node_name_pos_format()

	for i in players:
		move_player_to_coordinate(i, position_data[i.name])

func place_player_team_on_sideboard():
	for player in player_team.get_players():
		sideboard.request_to_place_on_sideboard(player)

func place_player_team_on_field():
	if sideboard:
		for player in player_team.get_players():
			sideboard.request_to_place_on_sideboard(player)
		return

	var position_data = player_team.get_position_data_from_file_node_name_pos_format()

	for player in player_team.get_players():
		move_player_to_coordinate(player, position_data[player.name])

func get_dodge_information(player_ag_value: int, from_coord: Vector2, target_coord: Vector2) -> int:
	var tackle_zone_squares = tackle_zone_component.get_opponent_tackle_zone_squares_map()

	var player_tackle_zone_value = tackle_zone_squares[from_coord]
	var target_tackle_zone_value = tackle_zone_squares[target_coord]
	if player_tackle_zone_value > 0 and target_tackle_zone_value == 0:
		return player_ag_value

	if player_tackle_zone_value > 0 and target_tackle_zone_value > 0:
		var output = player_ag_value + target_tackle_zone_value
		if output > 6:
			return 6
		return output

	return 0

func spawn_ball(ball_holdable: BallHoldableComponent):
	#check if there already is a ball
	if _ball != null:
		LogController.add_text("ERROR: Tried to spawn ball, already is a ball on the field")
		return
	
	# create ball _node
	var new_ball: Ball = load("res://teams/ball.tscn").instantiate()
	new_ball.set_ball_owner(ball_holdable)
	_ball = new_ball

func disable_field():
	#disable teams
	player_team.disable()
	opponent.disable()
	#disable field_squares
	for field_square in grid.field_squares:
		field_square.disable()

func get_ball() -> Ball:
	if _ball == null:
		LogController.add_text("ERROR: tried to get ball, No Ball Found On Field")
		return
	return _ball

## can only place if the ball has no owner defined, otherwise Call [method ball.force_nullify_ball_owner()] to clear current owner
func set_ball(ball: Ball, gridCoordinate: Vector2) -> void:
	_ball = ball
	var field_square: field_square_script.FieldSquare = field_map[gridCoordinate]
	_ball.set_ball_owner(NodeInspector.get_ball_holdable_component(field_square))

func is_ball_on_field() -> bool:
	var _owner: BallHoldableComponent = _ball.get_ball_owner()
	if _owner.get_parent() is field_square_script.FieldSquare:
		return true
	return false
