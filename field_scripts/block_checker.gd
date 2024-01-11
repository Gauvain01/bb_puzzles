class_name BlockChecker
extends Node2D

static func get_possible_block_targets(player:Player, field:Field) -> Array:
	var grid_coordinate = player.my_field_square.gridCoordinate
	var isOpponent:bool = player.isOpponent

	var surrounding_grid_coords = [
		Vector2(grid_coordinate.x + 1, grid_coordinate.y + 1),
		Vector2(grid_coordinate.x, grid_coordinate.y + 1),
		Vector2(grid_coordinate.x - 1, grid_coordinate.y + 1),
		Vector2(grid_coordinate.x + 1, grid_coordinate.y),
		Vector2(grid_coordinate.x - 1, grid_coordinate.y),
		Vector2(grid_coordinate.x, grid_coordinate.y - 1),
		Vector2(grid_coordinate.x + 1, grid_coordinate.y - 1),
		Vector2(grid_coordinate.x - 1, grid_coordinate.y - 1)
	]
	var targets = []
	for field_square in field.get_field_squares_by_grid_positions(surrounding_grid_coords):
		if field_square.get_occupied() == null:
			continue
		if not isOpponent:
			if field_square.occupied.get_occupied().isOpponent:
				targets.append(field_square.get_occupied())
		else:
			if not field_square.get_occupied().isOpponent:
				targets.append(field_square.get_occupied())

	return targets

static func evaluate_player_has_block_targets(player:Player, field:Field) -> bool:
	return len(get_possible_block_targets(player, field)) > 0
