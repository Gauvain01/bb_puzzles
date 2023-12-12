extends Object

class_name AstarUtil


class AstarNode:
	var parent
	var position
	var g = 0
	var h = 0
	var f = 0

	func _init(_parent, _position):
		self.parent = _parent
		self.position = _position

	func is_position_same(other):
		return self.position == other.position


static func calculate_diagonal_heuristic(
	curr_cell: Vector2, goal: Vector2, step_len: float = 1, diagonal_len: float = 1
):
	var dx = abs(curr_cell.x - goal.x)
	var dy = abs(curr_cell.y - goal.y)

	var h = step_len * max(dx, dy) + (diagonal_len - step_len) * min(dx, dy)
	return h


static func calculate_a_star_algo(
	start_coord: Vector2, goal_coord: Vector2, max_length, grid_map_allowance: Dictionary
):
	if typeof(grid_map_allowance.values()[0]) != TYPE_BOOL:
		assert(
			false,
			"TYPE:ERROR grid_map_allowance does not contain TYPE_BOOL as values, the map needs to represent Dictionary[Vector2:bool]"
		)
	if typeof(grid_map_allowance.keys()[0]) != TYPE_VECTOR2:
		assert(
			false,
			"TYPE:ERROR grid_map_allowance does not contain TYPE_VECTOR2 as keys, the map needs to represent Dictionary[Vector2:bool]"
		)

	var start_node = AstarNode.new(null, start_coord)
	var end_node = AstarNode.new(null, goal_coord)

	var open_arr = []
	var closed_arr = []

	open_arr.append(start_node)

	var break_n = 0
	while len(open_arr) > 0:
		break_n += 1
		if break_n > 30:
			return [start_coord]
		var current_node = open_arr[0]
		var current_index = 0

		for i in range(len(open_arr)):
			var item = open_arr[i]
			if item.f < current_node.f:
				current_node = item
				current_index = i

		open_arr.pop_at(current_index)
		closed_arr.append(current_node)

		if current_node.is_position_same(end_node) or break_n == max_length + 2:
			var path = []
			var current = current_node
			while current != null:
				path.append(current.position)
				current = current.parent
			path.reverse()
			path.pop_at(0)
			var output = []
			for i in range(len(path)):
				if i < max_length:
					output.append(path[i])
				else:
					break
			return output

		var children = []
		for new_position in Util.get_square_direction_vectors():
			var node_position = Vector2(
				current_node.position.x + new_position.x, current_node.position.y + new_position.y
			)

			if !grid_map_allowance.has(node_position):
				continue

			if !grid_map_allowance[node_position]:
				continue

			var new_node = AstarNode.new(current_node, node_position)

			children.append(new_node)

		for child in children:
			var _is_child_in_closed_list = false
			for closed_child in closed_arr:
				if child == closed_child:
					_is_child_in_closed_list = true
					break
			if _is_child_in_closed_list:
				continue

			child.g = current_node.g + 1
			child.h = (
				((child.position.x - end_node.position.x) ** 2)
				+ ((child.position.y - end_node.position.y) ** 2)
			)
			child.f = child.g + child.h

			for open_node in open_arr:
				if child.is_position_same(open_node) and child.g > open_node.g:
					continue
			open_arr.append(child)
