extends PanelContainer
class_name SideBoard

const ROWS = 2
const COLUMNS = 6
const SQUARE_SIZE = 35
const XFILL = 50
const YFILL = 50
var players_on_sideboard = 0

@export var field_squares = []
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
			
			add_child(field_square)

func request_to_place_on_sideBoard(board_piece):
	if len(field_squares) == 0:
		_generate_field_squares()
	for field_square in field_squares:
		#field_square.get_node("Select_Component").collision_Component.disabled = true
		if field_square.occupied == null:
			
			board_piece.global_position = field_square.global_position
			field_square.occupied = board_piece
			board_piece.my_field_square = field_square
			players_on_sideboard += 1
			
			break

	
func _ready():
	
	_generate_field_squares()
	print("done")


