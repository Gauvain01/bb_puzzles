@tool
extends Node2D


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

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
