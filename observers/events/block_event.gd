class_name BlockEventScript
class BlockEvent extends Node2D:
	var blocker:Player
	var target:Player
	var field:Field
	var active_push_event:PushEventScript.PushEvent 
	signal completed()
	signal surf_signal()
	var target_square
	
	func _init(blocker:Player, target:Player, field:Field):
		field.player_team.activate_ui_component_all_players(false)
		self.blocker = blocker
		self.target = target
		self.field = field
		self.target_square = target.my_field_square	
	
	func start():
		activate_block_menu_target()
		
	func activate_block_menu_target():
		target.ui_component.activate_block_menu(true)
		target.ui_component.block_menu_component.get_push_signal().connect(on_push_pressed)
		target.ui_component.block_menu_component.get_pow_signal().connect(on_pow_pressed)
		target.ui_component.block_menu_component.get_both_down_signal().connect(on_both_pressed)
	
	func on_pow_pressed():
		pass
	
	func on_both_pressed():
		pass
	
	func on_push_pressed():
		target.ui_component.activate_block_menu(false)
		self.active_push_event = PushEventScript.PushEvent.new(self)
		self.active_push_event.push_event_completed.connect(on_push_event_completed)
		add_child(active_push_event)
		active_push_event.start()
	
	func destroy():
		self.target.ui_component.activate_follow_stay_menu(false)
		self.target.ui_component.follow_stay_menu_component.clear_button_signals()
		self.queue_free()
	

	func on_push_event_completed():
		active_push_event.destroy()
		
		self.active_push_event = null
		self.completed.emit()
		field.player_team.activate_ui_component_all_players(true)
		self.destroy()
