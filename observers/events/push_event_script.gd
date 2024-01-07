class_name PushEventScript

class PushEvent extends Node2D:
	var blockEvent:BlockEventScript.BlockEvent
	var is_surf: bool = false
	var push_data_container = []
	signal push_event_completed()
	signal chain_push()
	signal request_to_surf_player(player:Player)
	
	func _init(block_event:BlockEventScript.BlockEvent):
		self.blockEvent = block_event
		
	func evaluate_and_run_push_action():
		var new_push_action = PushActionScript.PushAction.new(blockEvent.field, blockEvent.blocker, push_data_container)
		new_push_action.completed.connect(on_push_action_completed)
		new_push_action.start_push_action(blockEvent.target)
	
	func on_push_action_completed(container:Array):
		push_data_container = container
		evaluate_and_handle_push_data_container()
	
	func evaluate_and_handle_push_data_container():
		push_data_container.reverse() #need to reverse the container to do the last moves first to NOT place players on players
		for i in push_data_container:
			var push_data:PushActionScript.PushData = i
			
			match push_data.type:

				PushActionScript.PUSH_TYPE.NORMAL_PUSH:
					blockEvent.field.move_player_to_coordinate(push_data.player, push_data.position)
				PushActionScript.PUSH_TYPE.SURF:
					request_to_surf_player.emit(push_data.player)
				PushActionScript.PUSH_TYPE.CHAIN_PUSH:
					blockEvent.field.move_player_to_coordinate(push_data.player, push_data.position)
		
		activate_target_follow_stay_menu()


	func activate_target_follow_stay_menu():
		blockEvent.field.reset_field_state()
		blockEvent.target.ui_component.follow_stay_menu_component.get_follow_signal().connect(on_follow)
		blockEvent.target.ui_component.follow_stay_menu_component.get_stay_signal().connect(on_stay)
		blockEvent.target.ui_component.activate_follow_stay_menu()
	


	func on_stay():
		blockEvent.target.ui_component.show_menu(false)
		if is_surf:
			blockEvent.block_manager.field.remove_player_from_field(blockEvent.target)
			self.push_event_completed.emit()
			return
		
		self.push_event_completed.emit()
		
		
		
	func on_follow():
		blockEvent.target.ui_component.show_menu(false)
		var target_coord = blockEvent.target_square.gridCoordinate
		if is_surf:
			blockEvent.field.remove_player_from_field(blockEvent.target)
		blockEvent.field.move_player_to_coordinate(blockEvent.blocker, target_coord)
		self.push_event_completed.emit()
		
	
	func destroy():
		queue_free()

	func start():
		self.evaluate_and_run_push_action()
