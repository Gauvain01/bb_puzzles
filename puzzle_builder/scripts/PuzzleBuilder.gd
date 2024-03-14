class_name PuzzleBuilder
extends Node2D

@export var puzzle_builder_field: PuzzleBuilderField
@export var ui: PuzzleBuilderUiController

var _selected_puzzle_type: int
var _player_team_type:int

var _puzzle_type_drop_down_id_map = {
	0: PUZZLE_TYPE.SCORE
}

#subscribe to puzzle_type drop_down
func subscribe_puzzle_type_drop_down():
	var puzzle_menu: MenuButton = ui.puzzle_type_drop_down
	puzzle_menu.get_popup().id_pressed.connect(_on_puzzle_type_selected)

func _on_puzzle_type_selected(id: int):
	_selected_puzzle_type = _puzzle_type_drop_down_id_map[id]

func on_build_press():
	#validate
	if	!validate_score_puzzle():
		return
	 
	#build json
	#show json in scene

func build_puzzle_data() -> PuzzleData:
	var data = PuzzleData.new()
	data.set_game_version(GameController.get_game_version())
	data.set_puzzle_name(ui.puzzle_name_text.text)
	data.set_creator_name(ui.puzzle_creator_text.text)
	data.set_description(ui.puzzle_information_text.text)
	data.set_puzzle_type(_selected_puzzle_type)
	data.set_opponent_team_type(

#validate 

var validation_map = {}

func validate_score_puzzle() -> bool:
	#check if there are no more than 11 players on the field for each team
	var player_team_count = puzzle_builder_field.player_team.get_child_count()
	var opponent_team_count = puzzle_builder_field.opponent.get_child_count()

	if player_team_count > 11:
		LogController.add_text("ERROR: More than 11 players on the player team")
		return false
	if opponent_team_count > 11:
		LogController.add_text("ERROR: More than 11 players on opponent team")
		return false
	
	#validate if there is a ball on the field or a ball on a player
	var _ball:Ball = puzzle_builder_field.get_ball()
	var _ball_owner:BallHoldableComponent = _ball.get_ball_owner()

	if _ball_owner == null:
		LogController.add_text("ERROR: There is no ball on field or player")

	# check if puzzle_information_has_been_filled_in
	var puzzle_information_text: String = ui.puzzle_information_text.text
	if puzzle_information_text.is_empty():
		LogController.add_text("ERROR: Fill in Puzzle Information Before building")
		return false

	#check if puzzle_name has been filled in
	var puzzle_name_text = ui.puzzle_name_text
	if puzzle_name_text.is_empty():
		LogController.add_text("ERROR: Fill in Puzzle Name Before building")
		return false

	#check creator_name is filled in
	var creator_name_text = ui.puzzle_creator_text
	if creator_name_text.is_empty():
		LogController.add_text("ERROR: Fill in Puzzle creator name Before building")
		return false

	#check if a puzzle type is selected:
	if _selected_puzzle_type == null:
		LogController.add_text("ERROR no puzzle type selected")
		return false
	# check if there is a player in scoring range
	# including possible chain pushes
	return true
