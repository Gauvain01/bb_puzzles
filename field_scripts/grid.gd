class_name FieldGrid
extends Node2D

const COLUMNS = 15
const ROWS = 26
const SQUARE_SIZE = 35
const Y_FILL = 20
const X_FILL = 50
@export var field_squares = []
var ref = Callable(self, "draw_field_squares")

signal draw_field_squares
signal redraw_single_square(fieldSquare)
var firstEmit = true


func _generate_field_squares():
	for x in range(COLUMNS):
		for y in range(ROWS):
			var field_square_script = load("res://field_scripts/field_square_script.gd")

			var square_position = Vector2(x * SQUARE_SIZE + X_FILL, y * SQUARE_SIZE + Y_FILL)

			var size = Vector2(SQUARE_SIZE - 1, SQUARE_SIZE - 1)

			var square_color = Color.OLIVE
			var team

			if y < 13:
				team = "opponent"

			else:
				team = "player"

			var zone = "normal"
			if y == 25 or y == 0:
				zone = "endzone"

			if y == 12 or y == 13:
				if x > 3 and x < 11:
					zone = "los"

			if zone == "normal":
				if x < 4 or x > 10:
					zone = "sideline"

			var field_square = field_square_script.FieldSquare.new(
				square_position, team, zone, square_color, size, Vector2(x, y)
			)
			get_parent().player_coordinate_position_map[Vector2(x, y)] = field_square

			field_squares.append(field_square)
			add_child(field_square)
			field_square.z_as_relative = true
			field_square.z_index = -2


func _draw():
	draw_line(Vector2(50, 35 * 13 + 20), Vector2(50 + 15 * 35, 35 * 13 + 20), Color.WHITE, 3.0)
	draw_line(Vector2(50, 20 + 35), Vector2(50 + 15 * 35, 20 + 35), Color.WHITE, 3.0)
	draw_line(Vector2(50, 20 + 35 * 25), Vector2(50 + 15 * 35, 20 + 35 * 25), Color.WHITE, 3.0)
	draw_line(
		Vector2(50 + 35 * 4, 20 + 35), Vector2(50 + 35 * 4, 20 + 26 * 35 - 35), Color.WHITE, 3.0
	)
	draw_line(
		Vector2(50 + 35 * 11, 20 + 35), Vector2(50 + 35 * 11, 20 + 26 * 35 - 35), Color.WHITE, 3.0
	)


func _ready():
	_generate_field_squares()


func _process(_delta):
	if firstEmit:
		draw_field_squares.emit()

		firstEmit = false
