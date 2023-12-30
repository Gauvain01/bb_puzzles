extends Node

var _game_state:int = GAME_STATE.PAUSED

signal switched_game_state(new_state, old_state)

func switch_states(new_state:int):
	if _game_state != new_state:
		var old_state = get_game_state()
		_game_state = new_state
		switched_game_state.emit(new_state, old_state)

func get_game_state() -> int:
	return _game_state