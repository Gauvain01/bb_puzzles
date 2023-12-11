class_name SKILL_TYPE

enum {
	DODGE, 
	BLOCK,
	FRENZY
}

static var skill_type_string_map = {
	"DODGE":DODGE,
	"BLOCK":BLOCK,
	"FRENZY":FRENZY,
}

static func get_skill_type_string_map():
	return skill_type_string_map