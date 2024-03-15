class_name SKILL_TYPE

enum {
	DODGE, 
	BLOCK,
	FRENZY,
	GUARD,
	STAND_FIRM,
}

static var skill_type_string_map = {
	"DODGE":DODGE,
	"BLOCK":BLOCK,
	"FRENZY":FRENZY,
	"GUARD":GUARD,
	"STAND_FIRM":STAND_FIRM
}

static var _stringify_map = {
	DODGE:"DODGE",
	BLOCK:"BLOCK",
	FRENZY:"FRENZY",
	GUARD:"GUARD",
	STAND_FIRM:"STAND_FIRM",
}

static func get_skill_type_string_map():
	return skill_type_string_map

static func stringify(skill_type:int) -> String:
	return _stringify_map[skill_type]
	
