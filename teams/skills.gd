
class_name Skills
extends Node2D




@export var _skill_map = {
	"BLOCK":false, 
	"DODGE":false, 
	"FRENZY":false,
	"GUARD":false,
	"STAND_FIRM":false
}

var skill_map :Dictionary

signal skill_value_set(SKILL_TYPE)

func _ready():
	for key_word in _skill_map.keys():
		var type = SKILL_TYPE.get_skill_type_string_map()[key_word]
		skill_map[type] = _skill_map[key_word]

func get_skill_map() -> Dictionary:
	for key_word in _skill_map.keys():
		var type = SKILL_TYPE.get_skill_type_string_map()[key_word]
		skill_map[type] = _skill_map[key_word]
	return skill_map

func set_skill(skill_type:int, value:bool):
	var str_type = SKILL_TYPE.stringify(skill_type)
	_skill_map[str_type] = value
	
	
	
	

