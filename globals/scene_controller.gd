extends Node
#SceneController

signal changed_scene(new_scene:Dictionary)#{"scene_type":int, "puzzle_base":PuzzleBase}

var _current_scene:int
var _scene_scheduler = {}
var _is_scene_change_scheduled = false

const _ONE_TURN_SKAVEN_SIMPLE_PATH = "res://scenes/control.tscn"
const _VICTORY_SCREEN_PATH = "res://scenes/victory_screen.tscn"
const _MAIN_MENU_SCENE = "res://scenes/main_menu.tscn"

const SCENE_PATH_MAP = {
	SCENE.ONE_TURN_SKAVEN_SIMPLE:_ONE_TURN_SKAVEN_SIMPLE_PATH,
	SCENE.VICTORY_SCREEN:_VICTORY_SCREEN_PATH,
	SCENE.MAIN_MENU:_MAIN_MENU_SCENE,

}
var scene_name_map = {
	SCENE.VICTORY_SCREEN : "VictoryScreen",
	SCENE.MAIN_MENU : "MainMenu",
	SCENE.GENERATED : null,
	SCENE.TEST_PUZZLE_GENERATOR:"PuzzleGeneratorTest"
}

func _process(_delta: float) -> void:
	if _is_scene_change_scheduled:
		var _next_scene = _scene_scheduler["next_scene"]
		if _next_scene == SCENE.GENERATED:
			change_to_generated_scene(_scene_scheduler["generated_scene"])
		else:
			change_scene(_next_scene)

		_is_scene_change_scheduled = false

func change_scene(new_scene:int) -> void:

	get_tree().change_scene_to_file(SCENE_PATH_MAP[new_scene])

	_emit_changed_scenes(new_scene)
	_current_scene = new_scene

func _emit_changed_scenes(new_scene:int, puzzle_base = null):
		changed_scene.emit({"scene_type":new_scene, "puzzle_base":puzzle_base})

func change_to_generated_scene(generated_scene:Node):
	get_tree().root.get_node(scene_name_map[_current_scene]).free()
	get_tree().root.add_child(generated_scene)
	scene_name_map[SCENE.GENERATED] = generated_scene.name
	_emit_changed_scenes(SCENE.GENERATED, generated_scene)
	_current_scene = SCENE.GENERATED


func schedule_scene_change(scene_type, generated_scene = null):
	if scene_type == SCENE.GENERATED:
		_scene_scheduler["next_scene"] = SCENE.GENERATED
		_scene_scheduler["generated_scene"] = generated_scene
	else:
		_scene_scheduler["next_scene"] = scene_type	
	_is_scene_change_scheduled = true	

func get_current_scene() -> int:
	return _current_scene







