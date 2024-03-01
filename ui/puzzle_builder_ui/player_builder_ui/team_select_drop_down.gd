class_name TeamSelectDropDown
extends MenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().id_pressed.connect(_on_id_pressed)

func _on_id_pressed(id: int):
	var index = get_popup().get_item_index(id)
	text = get_popup().get_item_text(index)
