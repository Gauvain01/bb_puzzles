extends Node2D
class_name Field_Component

#var sideboard:SideBoard
#var grid:Node2D
#var selectionObserver:Node2D
#var util:Node2D
#var blockManager:BlockManager
#var player_team: TeamComponent
#var opponent_team: TeamComponent
#var tackle_zone_component:TackleZoneComponent
#var opponent:Node2D
#
#var player_coordinate_position_map = {}	
#var field_squares_draw_array = []
#var isDrawBox = true
#var isFieldSquaresDraw = false
#var isRedrawSingleSquare = false
#var singleSquareToRedraw
#var players_on_field = 0
#signal log_text(String)

#func move_player_to_coordinate(player:Player, coordinate:Vector2):
#	var player_square = player.my_field_square
#	var new_square = get_field_square_by_grid_position(coordinate)
#
#	if new_square.occupied != null:
#		assert(false, "cannot move player to occupied square, deal with occupied square first")
#
#	player_square.occupied = null
#	new_square.occupied = player
#
#	player.my_field_square = new_square
#	player.global_position = new_square.global_position
#
#func remove_player_from_field(player:Player):
#	var player_square = player.my_field_square
#	player_square.occupied = null
#	sideboard.request_to_place_on_sideBoard(player)
#	98
#
#
#
#
#func get_field_square_by_grid_position(coordinate):
#	if coordinate.x >= 0 and coordinate.y >= 0:
#				if coordinate.x < 15 and coordinate.y < 26:
#					return player_coordinate_position_map[coordinate]
#	assert(false, "coordinate is not on field, can not return target field_square_script" )
#func get_field_squares_by_grid_positions(gridPositions:Array) -> Array:
#	var output = []
#	for coordinate in gridPositions:
#			if coordinate.x >= 0 and coordinate.y >= 0:
#				if coordinate.x < 15 and coordinate.y < 26:
#					output.append(player_coordinate_position_map[coordinate])
#
#	return output
#
#func set_field_Squares_draw_flag():
#	for field_square in grid.field_squares:
#
#		field_squares_draw_array.append([[field_square._get_square_position(), field_square._get_size()], field_square._get_color()])
#	isFieldSquaresDraw = true
#
#	queue_redraw()
#
#func set_redraw_single_square_flag(field_square):
#	singleSquareToRedraw = field_square
#	isRedrawSingleSquare = true
#	queue_redraw()
#
#func is_grid_coordinate_out_of_bounds(coordinate) -> bool:
#
#		if coordinate.x >= 0 and coordinate.y >= 0:
#			if coordinate.x < 15 and coordinate.y < 26:
#				return false
#		return true
#
#
#
#func request_to_place_on_field(board_piece, field_square):
#	if field_square.occupied != null:
#		if field_square.player_team == "opponent":
#			log_text.emit("ERROR: you can't place your player on the opponents half of the pitch")
#
#			sideboard.request_to_place_on_sideBoard(board_piece)
#			return
#		log_text.emit("INFO: switched two players")
#		var holdingPiece = board_piece
#		var onFieldPiece = field_square.occupied
#		var holdingPieceTile = holdingPiece.my_field_square
#		var onFieldPieceTile = field_square
#		#if onFieldPieceTile.zone =="sideboard":
#			#get_parent().get_node("SideBoard").players_on_sideboard +=1
#		holdingPiece.my_field_square = field_square
#		holdingPiece.my_field_square.occupied = holdingPiece
#		holdingPiece.global_position = field_square.global_position
#
#		onFieldPiece.my_field_square = holdingPieceTile
#		onFieldPiece.my_field_square.occupied = onFieldPiece
#		onFieldPiece.global_position = onFieldPiece.my_field_square.global_position
#
#		return
#	print(board_piece)
#	board_piece.my_field_square.occupied = null
#	board_piece.my_field_square = null
#
#	if field_square.player_team == "opponent":
#		log_text.emit("ERROR: you can't place your player on the opponents half of the pitch")
#
#		sideboard.request_to_place_on_sideBoard(board_piece)
#		return
#	board_piece.global_position = field_square.global_position
#	field_square.occupied = board_piece
#	board_piece.my_field_square = field_square
#
#func request_to_place_opponent(player, gridCoordinate):
#	var field_square = player_coordinate_position_map[gridCoordinate]
#	player.my_field_square = field_square
#	player.my_field_square.occupied = player
#	player.global_position = field_square.global_position
#
#func _ready():
#	set_z_index(1)
#	grid.draw_field_squares.connect(set_field_Squares_draw_flag)
#	grid.redraw_single_square.connect(set_redraw_single_square_flag)
#	selectionObserver.request_to_place_on_field.connect(request_to_place_on_field)
#
#func _draw():
#	if isDrawBox:
#		draw_rect(Rect2(grid.X_FILL, grid.Y_FILL, grid.COLUMNS*grid.SQUARE_SIZE,grid.ROWS*grid.SQUARE_SIZE), Color.BLACK)
#	draw_line(Vector2(50, 35 * 13 + 20), Vector2(50 + 15 * 35, 35 * 13 + 20),Color.WHITE, 3.0 )
#	draw_line(Vector2(50, 20+ 35), Vector2(50 + 15 * 35, 20 + 35), Color.WHITE, 3.0)
#	draw_line(Vector2(50, 20 + 35 *25), Vector2(50 + 15 * 35, 20 + 35 * 25), Color.WHITE, 3.0)
#	draw_line(Vector2(50 + 35 * 4, 20 + 35), Vector2(50 + 35 * 4, 20 + 26 * 35 - 35),Color.WHITE, 3.0 )
#	draw_line(Vector2(50 + 35 * 11, 20 + 35), Vector2(50 + 35 * 11, 20 + 26 * 35 - 35),Color.WHITE, 3.0 )
#
#
#
#func isOnTheField(point: Vector2) -> bool:
#	var coordA
#	var coordB
#	var coordC
#	var coordD
#	var myPosition = global_position + Vector2(grid.X_FILL, grid.Y_FILL)
#	var eventPosition = point
#
#	coordA = myPosition
#	coordB = coordA + Vector2(grid.COLUMNS * grid.SQUARE_SIZE, 0)
#	coordD = coordA + Vector2(0, grid.ROWS * grid.SQUARE_SIZE)
#	coordC = Vector2(coordB.x, coordD.y)
#
#	return util.isInsideSquare(coordA, coordB, coordC, coordD, eventPosition)
#
#func get_player_gridPositions(player_team):
#	var squares = []
#	for player in player_team.get_children():
#		squares.append([player.my_field_square.gridCoordinate,player])
#	return squares
#
#func evaluate_possible_block_for_players():
#	print("evaluated positions for players")
#	for i in get_player_gridPositions(player_team):
#			var player:Player = i[1]
#			var gridCoordinate = i[0]
#			if blockManager.evaluate_player_has_block_targets(gridCoordinate):
#				var actionMenu:MenuButton = player.actionMenu
#				actionMenu.get_popup().set_item_disabled(1, false)
#
#
#func get_field_square_for_mouse_position(mouse_position:Vector2):
#	for i in grid.field_squares:
#		var square:field_square_script.FieldSquareClass = i
#
#		var coordA
#		var coordB
#		var coordC
#		var coordD
#		var myPosition = square.global_position + Vector2(35/2, 35/2)
#		var eventPosition = mouse_position
#
#		coordA = Vector2(myPosition.x - square.size.x, myPosition.y - square.size.y)
#		coordB = coordA + Vector2(square.size.x, 0)
#		coordD = coordA + Vector2(0, square.size.y)
#		coordC = Vector2(coordB.x, coordD.y)
#
#		if util.isInsideSquare(coordA, coordB, coordC, coordD, eventPosition):
#			return square
#
#
#func _on_game_controller_game_state_changed(game_state):
#	if game_state == GAME_STATE.PLAY:
#		evaluate_possible_block_for_players()
#
#func reset_field_state():
#	for i in grid.field_squares:
#		var square:field_square_script.FieldSquareClass = i
#		square.change_color(square.default_color)
#	tackle_zone_component._on_check_button_toggled(!tackle_zone_component.is_opponent_button_checked)
#	tackle_zone_component._on_tackle_zone_check_button_toggled(!tackle_zone_component.is_PlayerTeam_button_checked)
#	tackle_zone_component._on_check_button_toggled(tackle_zone_component.is_opponent_button_checked)
#	tackle_zone_component._on_tackle_zone_check_button_toggled(tackle_zone_component.is_PlayerTeam_button_checked)
#
