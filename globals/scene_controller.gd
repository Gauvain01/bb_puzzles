extends Node
#SceneController

signal changed_scene(previous_scene, new_scene)

var _current_scene:int

const _ONE_TURN_SKAVEN_SIMPLE_PATH = "res://scenes/control.tscn"
const _VICTORY_SCREEN_PATH = "res://scenes/victory_screen.tscn"

const SCENE_PATH_MAP = {
	SCENE.ONE_TURN_SKAVEN_SIMPLE:_ONE_TURN_SKAVEN_SIMPLE_PATH,
	SCENE.VICTORY_SCREEN:_VICTORY_SCREEN_PATH
}

func change_scene(new_scene:int) -> void:
	changed_scene.emit(_current_scene, new_scene)
	_current_scene = new_scene
	get_tree().change_scene_to_file(SCENE_PATH_MAP[new_scene])

func get_current_scene() -> int:
	return _current_scene







