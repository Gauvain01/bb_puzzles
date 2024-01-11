@tool
extends Node2D
const ROWS = 2
const COLUMNS = 6
const SQUARE_SIZE = 35
const XFILL = 50
const YFILL = 50
func _draw():
	draw_line(Vector2(position.x + XFILL, position.y + YFILL), Vector2(COLUMNS* SQUARE_SIZE + position.x + XFILL, position.y + YFILL), Color.BLACK)
	draw_line(Vector2(position.x + XFILL, position.y + YFILL), Vector2(position.x + XFILL, ROWS * SQUARE_SIZE + position.y + YFILL),Color.BLACK)

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()


