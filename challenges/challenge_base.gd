class_name ChallengeBase
extends Control

var game_state:GAME_STATE
@onready var field:Field = get_node("%field")
@onready var selection_observer:SelectionObserver = get_node("%SelectionObserver7")

signal game_state_changed(new_game_state:GAME_STATE)



func check_for_victory_condition():
	#responsible for monitoring victory conditions on the player.
	pass
	

func define_and_get_victory_condition() -> bool:
	return false


func set_game_state(new_game_state:GAME_STATE):
	game_state = new_game_state
	game_state_changed.emit(game_state)

func change_scene_to_victory_screen():
	pass



