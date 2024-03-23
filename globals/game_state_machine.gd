extends Node

var _game_state: int = GAME_STATE.PAUSED

signal switched_game_state(new_state, old_state)

func _ready() -> void:
	SceneController.changed_scene.connect(on_scene_switched)

func switch_states(new_state: int):
	if _game_state != new_state:
		var old_state = get_game_state()
		_game_state = new_state
		switched_game_state.emit(new_state, old_state)

func on_scene_switched(new_scene:Dictionary):
	if new_scene["scene_type"] == SCENE.GENERATED:
		var puzzle:PuzzleBase = new_scene["puzzle_base"]
		var puzzle_type = puzzle.puzzle_type

		if puzzle_type == PUZZLE_TYPE.SCORE:
			#are players on sideboard?	
			#change game state to play or setup
			if puzzle.are_players_on_sideboard():
				switch_states(GAME_STATE.SETUP)
			else:
				switch_states(GAME_STATE.PLAY)

func get_game_state() -> int:
	return _game_state
