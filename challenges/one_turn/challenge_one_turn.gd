class_name ChallengeOneturn
extends ChallengeBase

@onready var ui:UiController = get_node("%UI")
@onready var field:Field = get_node("%Field")


func _ready():
	GameStateMachine.switch_states(GAME_STATE.SETUP)
	ui.end_setup_button.pressed.connect(on_end_setup_button_click)
	field.place_opponent_team_on_field()
	field.place_player_team_on_sideboard()


func on_end_setup_button_click():
	GameStateMachine.switch_states(GAME_STATE.PLAY)

