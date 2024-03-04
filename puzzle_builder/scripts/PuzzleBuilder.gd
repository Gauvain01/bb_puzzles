class_name PuzzleBuilder
extends Node2D

@export var puzzle_builder_field: PuzzleBuilderField
@export var ui: PuzzleBuilderUiController

var _selected_puzzle_type: int

var _puzzle_type_drop_down_id_map = {
	0: PUZZLE_TYPE.SCORE
}

#subscribe to puzzle_type drop_down
func subscribe_puzzle_type_drop_down():
	var puzzle_menu: MenuButton = ui.puzzle_type_drop_down
	puzzle_menu.get_popup().id_pressed.connect(_on_puzzle_type_selected)

func _on_puzzle_type_selected(id: int):
	_selected_puzzle_type = _puzzle_type_drop_down_id_map[id]

#validate puzzle

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
	if !puzzle_builder_field.is_ball_on_the_field():
		# check if player has ball
		var opponents = puzzle_builder_field.opponent.get_childen()
		var player_team_players = puzzle_builder_field.player_team.get_children()

		var _loop_arr = []
		_loop_arr.append_array(opponents)
		_loop_arr.append_array(player_team_players)
		
		var _i = 0
		var max_i = len(_loop_arr) - 1

		while true:
			if _i > max_i:
				LogController.add_text("ERROR: There is no ball on field or player")
				return false

			var player: Player = _loop_arr[_i]

			if player.has_ball:
				break
			
			_i += 1

	# check if puzzle_information_has_been_filled_in
	var puzzle_information_text: String = ui.puzzle_information_text.text
	if puzzle_information_text.is_empty():
		LogController.add_text("ERROR: Fill in Puzzle Information Before building")
		return false
	
	# check if there is a player in scoring range
	# including possible chain pushes
	return true