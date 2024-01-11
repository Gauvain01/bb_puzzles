class_name OneTurnPuzzle
extends PuzzleBase

@onready var ui:UiController = get_node("%Ui")
@onready var field:Field = get_node("%Field")
var sideboard:SideBoardController 


func _ready():
	sideboard = field.sideboard
	GameStateMachine.switch_states(GAME_STATE.SETUP)
	ui.end_setup_button.pressed.connect(on_end_setup_button_click)
	field.place_opponent_team_on_field()
	field.place_player_team_on_sideboard()


func on_end_setup_button_click():
	if sideboard.get_side_board_player_count() == 0:
		GameStateMachine.switch_states(GAME_STATE.PLAY)
	else:
		LogController.add_text("place all players on the board")

