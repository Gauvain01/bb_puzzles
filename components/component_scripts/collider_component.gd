extends Area2D
class_name ColliderComponent
var collision_shape:CollisionShape2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape = get_node("CollisionShape2D")


func is_mouse_in_collider() -> bool:
	var point = get_viewport().get_mouse_position()
	var pos = global_position
	var SQUARE_SIZE = collision_shape.shape.get_rect().size * scale
	var x = point.x
	var y = point.y
	
	if x >= (pos.x - (SQUARE_SIZE.x/2)) and x <= (pos.x + (SQUARE_SIZE.x/2)):
		if y >= (pos.y - (SQUARE_SIZE.y/2)) and y <= (pos.y + (SQUARE_SIZE.y/2)):
			return true
		else:
			return false
	else:
		return false
