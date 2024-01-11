class_name SideBoardController
extends Node2D
const ROWS = 2
const COLUMNS = 6
const SQUARE_SIZE = 35
const XFILL = 50
const YFILL = 50
var players_on_sideboard = 0
var side_board_map = {} #{Player:Square}
var available_field_squares = []
var field_squares = []



func get_side_board_player_count() -> int:
	var _count = 0
	for key:Player in side_board_map.keys():
		if key.my_field_square.zone == "sideboard":
			_count =+ 1
	return _count

func _generate_field_squares():
	if len(field_squares) != 0:
		return
	for x in range(COLUMNS):
		for y in range(ROWS):
			
			var field_square_script = load("res://field_scripts/field_square_script.gd")
			var square_position = Vector2(x*SQUARE_SIZE + 50, y*SQUARE_SIZE + 50)

			var size = Vector2(SQUARE_SIZE-1,SQUARE_SIZE-1)

			var square_color = Color.GRAY
			var team = "none"

			var zone = "sideboard"

			var field_square = await field_square_script.FieldSquare.new(square_position, team, zone, square_color, size, Vector2(x,y) )
			field_squares.append(field_square)
			available_field_squares.append(field_square)
			add_child(field_square)

func request_to_place_on_sideboard(player:Player):
	if len(field_squares) == 0:
		_generate_field_squares()

	if not side_board_map.has(player):
		side_board_map[player] = available_field_squares.pop_back()
	
	var square = side_board_map[player]
	player.global_position = square.global_position
	square.occupied = player
	player.my_field_square = square
	players_on_sideboard += 1

func _ready():
	
	_generate_field_squares()
