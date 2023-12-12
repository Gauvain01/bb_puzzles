extends Sprite2D

var is_opponent = null


func change_to_select_color():
	set_modulate("#ffff00")


func draw_team_overlay():
	queue_redraw()

func _draw():
	if is_opponent == null:
		return
	
	var texture_width = texture.get_width()
	var texture_height = texture.get_height()

	var coordA = Vector2(position.x - texture_width/2, position.y - texture_height/2)
	var coordB = Vector2(coordA.x + texture_width, coordA.y)
	var coordC = Vector2(coordA.x, coordA.y + texture_height)
	var coordD = Vector2(coordC.x + texture_width, coordC.y)

	var color = Color.BLUE

	if is_opponent:
		color = Color.RED
	
	draw_line(coordA, coordB, color, 10)
	draw_line(coordA, coordC, color, 10)
	draw_line(coordB, coordD, color, 10)
	draw_line(coordD, coordC, color, 10)


func change_to_unselect_color():
	set_modulate("#ffffff")
