
class_name MoveEventScript

class MoveEvent extends Node2D:
	var field:Field
	
	var player:Player
	var available_movement
	var selection_observer: SelectionObserver
	var end_turn_button:MenuButton
	signal is_completed
	signal instantiated
	var locked_in_path = []
	var temp_path = []
	var gfi = 2
	var current_selected_square
	var _movement_count_for_dice_log_evaluation
	var not_obstacle_map
	var total_movement
	
	func _init(field:Field, player:Player, selection_observer:SelectionObserver):
		field.player_team.set_all_active_players_to_idle_state()
		player.state_machine.switch_state(PLAYER_STATE.ACTIVE_STATE)
		self.field = field
		self.player = player
		self.instantiated.emit()
		self.available_movement = self.player.stats.MA + 2
		self._movement_count_for_dice_log_evaluation = self.player.stats.MA + 2
		self.total_movement = self.player.stats.MA + 2
	
		self.selection_observer = selection_observer
		self.selection_observer.hover_left.connect(on_hover_left)
		
		self.current_selected_square = player.my_field_square
		self.not_obstacle_map = field.get_not_obstacle_map()
	
	func start():
		disable_action_menu_for_player()
		start_listening_for_click_on_available_movement_squares()
		
	func on_hover_left(square):
		var slc:SelectComponent = NodeInspector.get_select_component(square)
		if slc.selected.is_connected(on_movement_square_clicked):
			slc.selected.disconnect(on_movement_square_clicked)
			
	func on_hover_square(square:field_square_script.FieldSquare):
		calculate_and_color_temp_path(square)
	
	func calculate_and_color_temp_path(square:field_square_script.FieldSquare):
		
		if len(temp_path) >0:
			for i in temp_path:
				var sqr:field_square_script.FieldSquare = field.get_field_square_by_grid_position(i)
				sqr.color_to_default()
				
		for coord in locked_in_path:
			var sqr:field_square_script.FieldSquare = field.get_field_square_by_grid_position(coord)
			sqr.change_color(Color.LAWN_GREEN)
		
		temp_path = []
		
		if square.occupied != null:
			return
			
		temp_path = AstarUtil.calculate_a_star_algo(
			current_selected_square.gridCoordinate,
			square.gridCoordinate,
			self.available_movement,
			self.not_obstacle_map)
		
		if temp_path == null:
			temp_path = []
			return
		
		for coord in temp_path:
			var sqr:field_square_script.FieldSquare = field.get_field_square_by_grid_position(coord)
			sqr.change_color(Color.LAWN_GREEN)
		
		_display_rush_squares_for_selected_path(temp_path)

		if square.gridCoordinate in temp_path:
			var slc:SelectComponent = NodeInspector.get_select_component(square)
			slc.selected.connect(on_movement_square_clicked)
				
	func on_movement_square_clicked(square):

		self.available_movement -= len(temp_path)
		
		if square.gridCoordinate == locked_in_path.back():
			on_space_pressed()
			
		lock_in_temp_path()
		current_selected_square = square
		if InputBus.is_signal_connected_to_callable(self, InputBus.spacePressed, on_space_pressed):
			InputBus.unsubscribe_from_signal(self, InputBus.spacePressed)
		
		if InputBus.is_signal_connected_to_callable(self, InputBus.rightMouseClick, on_right_mouse_clicked):
			InputBus.unsubscribe_from_signal(self, InputBus.rightMouseClick)
		
		InputBus.subscribe_to_right_mouse_click_event(self, on_right_mouse_clicked)
		InputBus.subscribe_to_space_pressed_event(self, on_space_pressed)
		
		
	func on_right_mouse_clicked():
		InputBus.unsubscribe_from_signal(self, InputBus.rightMouseClick)
		reset()
		
	func on_space_pressed():
		InputBus.unsubscribe_from_signal(self, InputBus.spacePressed)
		InputBus.unsubscribe_from_signal(self, InputBus.rightMouseClick)
		self.selection_observer.hover_square.disconnect(on_hover_square)
		
		_move_player_and_add_dice_rolls_to_log()

		on_end_turn_button_click()
		
	func is_square_in_opponent_tackle_zone(square):
		return field.tackle_zone_component.is_in_opponent_tackle_zone(square.gridCoordinate)
			

	func _move_player_and_add_dice_rolls_to_log():

		var dodge_values_for_locked_in_path = _get_dodge_values_for_locked_in_path()
		var rush_values_for_locked_in_path = _get_rush_values_for_locked_in_path()

		for target_coord in locked_in_path:

			var dodge_value = dodge_values_for_locked_in_path[target_coord]
			var rush_value = rush_values_for_locked_in_path[target_coord]
			
			if dodge_value != 0:
				LogController.add_text(str(player.name) + " dodged on a " + str(dodge_value) + "+")
				DiceLog.add_test_dice_roll(dodge_value, ENUMS.DICE_ROLL_TYPE.DODGE)
			if rush_value != 0:
				LogController.add_text(str(player.name)+" performed a rush on a 2+")
				DiceLog.add_test_dice_roll(rush_value, ENUMS.DICE_ROLL_TYPE.RUSH)
			
			field.move_player_to_coordinate(player, target_coord)

			self._movement_count_for_dice_log_evaluation -= 1


	func _display_dice_rolls_for_locked_in_path():

		var dodge_values_for_locked_in_path = _get_dodge_values_for_locked_in_path()
		var rush_values_for_locked_in_path = _get_rush_values_for_locked_in_path()

		for target_coord in locked_in_path:

			var dodge_value = dodge_values_for_locked_in_path[target_coord]
			var rush_value = rush_values_for_locked_in_path[target_coord]
			var square:field_square_script.FieldSquare = field.get_field_square_by_grid_position(target_coord)

			if dodge_value != 0:
				square.rollDisplayComponent.activate(true)
				square.rollDisplayComponent.add_dice_roll(DiceRollData.new(dodge_value, ENUMS.DICE_ROLL_TYPE.DODGE))

			if rush_value != 0:
				square.rollDisplayComponent.activate(true)
				square.rollDisplayComponent.add_dice_roll(DiceRollData.new(rush_value, ENUMS.DICE_ROLL_TYPE.RUSH))
	
	func _display_rush_squares_for_selected_path(selected_path:Array):
		var counter = 1
		for target_coord in locked_in_path + selected_path :
			if counter <= _movement_count_for_dice_log_evaluation - 2:
				counter += 1
				continue
			
			var square:field_square_script.FieldSquare = field.get_field_square_by_grid_position(target_coord)
			square.change_color(Color.PINK)
			counter += 1
	
	func _get_dodge_values_for_locked_in_path() -> Dictionary:
		var output = {}
		
		var from_coord = player.my_field_square.gridCoordinate

		for target_coord in locked_in_path:

			var dodge_value = field.get_dodge_information(player.stats.AG, from_coord, target_coord)
			
			from_coord = target_coord
			output[target_coord] = dodge_value

		return output

	func _get_rush_values_for_locked_in_path() -> Dictionary:
		var counter = 1

		var output = {}

		for target_coord in locked_in_path:

			if counter <= _movement_count_for_dice_log_evaluation - 2:
				output[target_coord] = 0
				counter += 1
				continue

			output[target_coord] = 2
			counter += 1

		return output
			
	func start_listening_for_click_on_available_movement_squares():
		
		self.selection_observer.hover_square.connect(on_hover_square)
			
	
	func lock_in_temp_path():
		locked_in_path += temp_path
		#evaluate_dice_rolls_for_move()
		_display_dice_rolls_for_locked_in_path()
		
		
	func disable_action_menu_for_player():
		
		player.ui_component.action_menu_component.blitz_button.disabled = true
		player.ui_component.action_menu_component.move_button.disabled = true
		player.ui_component.action_menu_component.block_button.disabled = true
		player.ui_component.action_menu_component.end_player_action_button.disabled = false
		
		
		player.ui_component.action_menu_component.get_end_action_signal().connect(on_end_turn_button_click, CONNECT_ONE_SHOT)
		
	func on_end_turn_button_click():
		
		
		for i in locked_in_path:
			field.get_field_square_by_grid_position(i).rollDisplayComponent.activate(false)
		
		field.reset_field_state()
		
		is_completed.emit()
		destroy()
	
	
	func reset():
		for i in locked_in_path:
			field.get_field_square_by_grid_position(i).rollDisplayComponent.activate(false)
		field.reset_field_state()
		
		self._movement_count_for_dice_log_evaluation = self.total_movement
		self.available_movement = self.total_movement
		self.current_selected_square = player.my_field_square
		locked_in_path = []
		temp_path = []
		start()
	func temp_path_finding_to_hovered_square():
		pass
		
		
	func destroy():
		self.queue_free()
			
			

class BlitzMoveEvent extends MoveEvent:

	func _init(field:Field, player:Player, selection_observer:SelectionObserver):
		super(field, player, selection_observer)
		self.available_movement = self.player.stats.MA + 1
		self._movement_count_for_dice_log_evaluation = self.player.stats.MA + 1

	func on_end_turn_button_click():
		for i in self.locked_in_path:
			self.field.get_field_square_by_grid_position(i).rollDisplayComponent.activate(false)
		
		self.field.reset_field_state()
		self.selection_observer.hover_square.disconnect(on_hover_square)
		self.selection_observer.hover_left.disconnect(on_hover_left)
		self.locked_in_path = []
		
		self.is_completed.emit()
		
	func restart():
		if self._movement_count_for_dice_log_evaluation > 0:
			var new_move_event = MoveEvent.new(self.field,self.player, self.selection_observer)
			new_move_event.available_movement = self._movement_count_for_dice_log_evaluation
			new_move_event._movement_count_for_dice_log_evaluation = self._movement_count_for_dice_log_evaluation
			new_move_event.total_movement = self._movement_count_for_dice_log_evaluation
			get_parent().add_child(new_move_event)
			new_move_event.start()
			new_move_event.is_completed.connect(relay_completed_event)
		
		else:
			self.is_completed.emit()
			destroy()
		
	func relay_completed_event():
		self.is_completed.emit()
		destroy()
	
	func reset():
		for i in locked_in_path:
			field.get_field_square_by_grid_position(i).rollDisplayComponent.activate(false)
		field.reset_field_state()
		
		self._movement_count_for_dice_log_evaluation = self.player.stats.MA + 1
		self.available_movement = self.player.stats.MA + 1
		self.current_selected_square = player.my_field_square
		locked_in_path = []
		temp_path = []
		start()
	
