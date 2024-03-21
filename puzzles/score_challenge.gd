class_name ScorePuzzle
extends PuzzleBase


func has_player_ball_and_is_in_endzone(player: Player, to_coord: Vector2) -> bool:
	if player.has_ball:
		if field.get_field_square_by_grid_position(to_coord).zone == "endzone":
			return true

	return false


func _on_player_moved(player: Player):
	if has_player_ball_and_is_in_endzone(player, player.my_field_square.gridCoordinate):
		super.start_victory()


func _ready():
	field.moved_player_during_play.connect(_on_player_moved)
