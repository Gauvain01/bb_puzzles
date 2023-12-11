@tool
extends Node2D
class_name  BlockDiceViewer
var isActive
var die_amount = 0
var isAgainst:bool = false
var die_color:Color = Color.GREEN_YELLOW

@export var die_size:Vector2 = Vector2(5,5)
func _ready():
	queue_redraw()


func _draw():
	if die_amount == 0:
		return
	
	
	
	for i in range(die_amount):
		var rect = Rect2(Vector2(self.position.x - 25/2, self.position.y - 30/2), die_size)
		if i > 0:
			rect = Rect2(Vector2(rect.position.x + (die_size.x * i) + (1 * i), rect.position.y), die_size)
			draw_rect(rect, die_color)
		else:
			draw_rect(rect, die_color)



func activate(isActive:bool, isAgainst = false, die_amount = 0):
	if isActive == false:
		print("deactivated")
	self.isAgainst = isAgainst
	change_die_color(isAgainst)
	self.die_amount = die_amount
	visible = isActive
	queue_redraw()

func change_die_color(isAgainst):
	if isAgainst:
		die_color = Color.RED
	else:
		die_color = Color.GREEN_YELLOW
		


