extends  Node
class_name PushActionScript

enum PUSH_TYPE {
	NORMAL_PUSH,
	CHAIN_PUSH,
	SURF
}

enum DIRECTION_ENUM {RIGHT, LEFT, DOWN, UP, RIGHT_UP, LEFT_UP, LEFT_DOWN, RIGHT_DOWN}

class PushData extends  Node:
	var player:Player
	var position:Vector2
	var type

	func _init(player:Player, target_position:Vector2, push_type:PUSH_TYPE):
		self.player = player
		self.position = target_position
		self.type = push_type        


class PushAction extends Node2D:

	var target_player:Player
	var chain_target_player:Player
	var chain_target_square:field_square_script.FieldSquare
	var _possible_targets:Array
	var blocker:Player
	var field:Field
	var push_data_container:Array

	signal completed(push_data_container)

	func _init(field, blocker, push_data_container):
		self.field = field
		self.blocker = blocker
		self.push_data_container = push_data_container




	func start_push_action(target:Player):
		self.target_player = target
		if check_for_chainpush(blocker, target_player):

				var new_chain_push = PushAction.new(field, target, push_data_container)
				add_child(new_chain_push)
				new_chain_push.completed.connect(on_chain_push_completed)

				var chain_push_targets = []
				for i in get_push_direction(blocker, target_player):
					var possible_chain_target:Player = field.get_field_square_by_grid_position(target_player.my_field_square.gridCoordinate + i).occupied
					chain_push_targets.append(possible_chain_target)
				
				new_chain_push.start_chain_push_action(chain_push_targets)
				return
			
		if check_for_surf(blocker, target_player):
			var push_data = PushData.new(target_player, Vector2(0,0), PUSH_TYPE.SURF)
			push_data_container.append(push_data)
			complete()
			return
		
		_possible_targets = []
		for i in get_push_direction(blocker, target_player):
			var possible_chain_target:field_square_script.FieldSquare = field.get_field_square_by_grid_position(target_player.my_field_square.gridCoordinate + i)
			if possible_chain_target.occupied == null:
				_possible_targets.append(possible_chain_target)
				NodeInspector.get_select_component(possible_chain_target).selected.connect(on_push_square_select_for_normal_push)
				possible_chain_target.default_color = Color.WHITE
				possible_chain_target.color_to_default()
		return

	func start_chain_push_action(targets:Array):
		for i in targets:
			_possible_targets.append(i)
			var target:Player = i
			target.select_component.selected.connect(listen_for_target_select)
			target.change_color(Color.ORANGE)
	
	func listen_for_target_select(target:Player):
		for i in _possible_targets:
			i.select_component.selected.disconnect(listen_for_target_select)
			i.change_color(i.default_color)
			
		target_player = blocker
		on_possible_chain_target_select(target)
		return
		
	func on_possible_chain_target_select(chain_target:Player) -> void:

		for i in _possible_targets:
			i.select_component.selected.disconnect(on_possible_chain_target_select)
		chain_target_player = chain_target
		
		if check_for_chainpush(target_player, chain_target_player):
			var push_data = PushData.new(target_player, chain_target_player.my_field_square.gridCoordinate, PUSH_TYPE.CHAIN_PUSH)
			push_data_container.append(push_data)

			var new_chain_push = PushAction.new(field, chain_target_player, push_data_container)
			add_child(new_chain_push)
			new_chain_push.completed.connect(on_chain_push_completed)

			var chain_push_targets = []
			for i in get_push_direction(target_player, chain_target_player):
				var possible_chain_target:Player = field.get_field_square_by_grid_position(chain_target_player.my_field_square.gridCoordinate + i).occupied
				chain_push_targets.append(possible_chain_target)
			
			new_chain_push.start_chain_push_action(chain_push_targets)
			return
		
		if check_for_surf(target_player, chain_target_player):
			var push_data = PushData.new(chain_target_player, Vector2(0,0), PUSH_TYPE.SURF)
			push_data_container.append(push_data)
			complete()
			return

		_possible_targets = []
		for i in get_push_direction(target_player, chain_target_player):
			var possible_chain_target:field_square_script.FieldSquare = field.get_field_square_by_grid_position(chain_target_player.my_field_square.gridCoordinate + i)
			if possible_chain_target.occupied == null:
				_possible_targets.append(possible_chain_target)
				NodeInspector.get_select_component(possible_chain_target).selected.connect(on_push_square_select_for_chain_push)
				possible_chain_target.default_color = Color.WHITE
				possible_chain_target.color_to_default()

		var new_push_data = PushData.new(target_player, chain_target_player.my_field_square.gridCoordinate, PUSH_TYPE.NORMAL_PUSH)
		push_data_container.append(new_push_data)
		return
	
	func on_push_square_select_for_normal_push(square:field_square_script.FieldSquare):
		for i in _possible_targets:
			NodeInspector.get_select_component(i).selected.disconnect(on_push_square_select_for_normal_push)
			var possible_square:field_square_script.FieldSquare = i
			possible_square.change_color(possible_square._field_color)
			
		var push_data = PushData.new(target_player, square.gridCoordinate, PUSH_TYPE.NORMAL_PUSH)
		push_data_container.append(push_data)
		complete()

	func on_push_square_select_for_chain_push(square:field_square_script.FieldSquare):
		for i in _possible_targets:
			var possible_square:field_square_script.FieldSquare = i
			possible_square.change_color(possible_square._field_color)
			NodeInspector.get_select_component(i).selected.disconnect(on_push_square_select_for_chain_push)
		var push_data = PushData.new(chain_target_player, square.gridCoordinate, PUSH_TYPE.NORMAL_PUSH)
		push_data_container.append(push_data)
		complete()

	func on_chain_push_completed(container):
		self.push_data_container = container
		complete()
	
	func check_for_surf(blocker:Player, target:Player):
		for i in get_push_direction(blocker, target):
			var coord = i + target.my_field_square.gridCoordinate
			if field.is_grid_coordinate_out_of_bounds(coord):
				return true
		return false

	func complete():
		completed.emit(self.push_data_container)
		self.queue_free()

	func check_for_chainpush(blocker:Player, target:Player) -> bool:
		for i in get_push_direction(blocker, target):
			var coord = i + target.my_field_square.gridCoordinate
			if field.is_grid_coordinate_out_of_bounds(coord):
				return false
			if field.get_field_square_by_grid_position(coord).occupied == null:
				return false
		return true

	func get_block_direction_between_blocker_and_target(blocker:Player, target:Player) -> DIRECTION_ENUM:
		var block_direction_map = {
			Vector2(1,0):DIRECTION_ENUM.RIGHT,
			Vector2(-1,0):DIRECTION_ENUM.LEFT,
			Vector2(0,1):DIRECTION_ENUM.DOWN,
			Vector2(0,-1):DIRECTION_ENUM.UP,
			Vector2(1,1):DIRECTION_ENUM.RIGHT_DOWN,
			Vector2(1,-1):DIRECTION_ENUM.RIGHT_UP,
			Vector2(-1,1):DIRECTION_ENUM.LEFT_DOWN,
			Vector2(-1,-1):DIRECTION_ENUM.LEFT_UP,
		}
		var relative_position = blocker.my_field_square.gridCoordinate - target.my_field_square.gridCoordinate
		var block_direction = block_direction_map[relative_position]
		return block_direction
		
	func get_push_direction(blocker:Player, target:Player) -> Array:
		var block_direction = get_block_direction_between_blocker_and_target(blocker, target);
		var directions
		
		
		match block_direction:

			DIRECTION_ENUM.RIGHT:
				directions = [DIRECTION_ENUM.LEFT, DIRECTION_ENUM.LEFT_UP, DIRECTION_ENUM.LEFT_DOWN]
			DIRECTION_ENUM.LEFT:
				directions = [DIRECTION_ENUM.RIGHT, DIRECTION_ENUM.RIGHT_DOWN, DIRECTION_ENUM.RIGHT_UP]
			DIRECTION_ENUM.DOWN:
				directions = [DIRECTION_ENUM.UP, DIRECTION_ENUM.LEFT_UP, DIRECTION_ENUM.RIGHT_UP]
			DIRECTION_ENUM.UP:
				directions = [DIRECTION_ENUM.DOWN, DIRECTION_ENUM.LEFT_DOWN, DIRECTION_ENUM.RIGHT_DOWN]
			DIRECTION_ENUM.RIGHT_DOWN:
				directions = [DIRECTION_ENUM.UP, DIRECTION_ENUM.LEFT_UP, DIRECTION_ENUM.LEFT]
			DIRECTION_ENUM.RIGHT_UP:
				directions = [DIRECTION_ENUM.DOWN, DIRECTION_ENUM.LEFT_DOWN, DIRECTION_ENUM.LEFT]
			DIRECTION_ENUM.LEFT_DOWN:
				directions = [DIRECTION_ENUM.UP, DIRECTION_ENUM.RIGHT_UP, DIRECTION_ENUM.RIGHT]
			DIRECTION_ENUM.LEFT_UP:
				directions = [DIRECTION_ENUM.DOWN, DIRECTION_ENUM.RIGHT_DOWN, DIRECTION_ENUM.RIGHT]

		var block_direction_map = {
			DIRECTION_ENUM.RIGHT:Vector2(1,0),
			DIRECTION_ENUM.LEFT:Vector2(-1,0),
			DIRECTION_ENUM.DOWN:Vector2(0,1),
			DIRECTION_ENUM.UP:Vector2(0,-1),
			DIRECTION_ENUM.RIGHT_DOWN:Vector2(1,1),
			DIRECTION_ENUM.RIGHT_UP:Vector2(1,-1),
			DIRECTION_ENUM.LEFT_DOWN:Vector2(-1,1),
			DIRECTION_ENUM.LEFT_UP:Vector2(-1,-1),
		}
		var output = []
		for i in directions:
			output.append(block_direction_map[i])
		return output
		

		



	

		

