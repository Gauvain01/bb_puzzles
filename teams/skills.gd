
class_name Skills
extends Node2D




@export var _skill_map = {
	"BLOCK":false, 
	"DODGE":false, 
	"FRENZY":false,
}

var skill_map :Dictionary

func _ready():
	for key_word in _skill_map.keys():
		var type = SKILL_TYPE.get_skill_type_string_map()[key_word]
		skill_map[type] = _skill_map[key_word]

func get_skill_map() -> Dictionary:
	return skill_map
