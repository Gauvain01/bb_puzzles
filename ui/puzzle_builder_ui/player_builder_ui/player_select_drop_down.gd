class_name PlayerSelectDropDown
extends MenuButton

var _id: int = 0
var id_player_map = {}

signal player_pressed(player_type_string: String)

func clear():
	if get_popup().id_pressed.is_connected(on_id_pressed):
		get_popup().id_pressed.disconnect(on_id_pressed)
	id_player_map = {}
	_id = 0

func add_player(player_type_string: String) -> int:

	if !get_popup().id_pressed.is_connected(on_id_pressed):
		get_popup().id_pressed.connect(on_id_pressed)
		
	get_popup().add_item(player_type_string, _id)
	var old_id = _id
	id_player_map[old_id] = player_type_string
	_id += 1
	return old_id

func on_id_pressed(id):
	var player_type_string = id_player_map[id]
	player_pressed.emit(player_type_string)
