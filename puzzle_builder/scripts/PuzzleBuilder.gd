class_name PuzzleBuilder
extends Node2D

@export var puzzle_builder_field: PuzzleBuilderField
@export var ui: PuzzleBuilderUiController

var _selected_puzzle_type: int
var _player_team_type:int
var _opponent_team_type:int

var _puzzle_type_drop_down_id_map = {
	0: PUZZLE_TYPE.SCORE
}

func _ready():
	puzzle_builder_field.refreshed_player_team.connect(func(x):_player_team_type = x)
	puzzle_builder_field.refreshed_opponent_team.connect(func (x): _opponent_team_type = x)
	ui.build_button.pressed.connect(on_build_press)

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
	var data:PuzzleData = build_puzzle_data()
	var json_string = PuzzleData.PuzzleDataParser.stringify_to_json(data)
	 
	#call ui to show json_string 
	ui.show_build_screen_with_json_data(json_string)

func build_puzzle_data() -> PuzzleData:
	var data = PuzzleData.new()
	data.set_game_version(GameController.get_game_version())
	data.set_puzzle_name(ui.puzzle_name_text.text)
	data.set_creator_name(ui.puzzle_creator_text.text)
	data.set_description(ui.puzzle_information_text.text)
	data.set_puzzle_type(_selected_puzzle_type)
	data.set_opponent_team_type(_opponent_team_type)
	data.set_player_team_type(_player_team_type)
	data.set_opponent_team(puzzle_builder_field.opponent.get_players())
	data.set_player_team(puzzle_builder_field.player_team.get_players())
	data.set_is_ball_on_field(puzzle_builder_field.is_ball_on_field())

	var ball_owner_parent = puzzle_builder_field.get_ball().get_ball_owner().get_parent()
	var ballcoord:Vector2
	if ball_owner_parent is Player:
		ballcoord = ball_owner_parent.my_field_square.gridCoordinate
	else:
		ballcoord = ball_owner_parent.gridCoordinate
		
	data.set_ball_position(ballcoord)
	return data

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
	var puzzle_name_text = ui.puzzle_name_text.text
	if puzzle_name_text.is_empty():
		LogController.add_text("ERROR: Fill in Puzzle Name Before building")
		return false

	#check creator_name is filled in
	var creator_name_text = ui.puzzle_creator_text.text
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
