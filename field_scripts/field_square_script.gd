class_name field_square_script


class FieldSquare:
	extends Area2D

	var square_position
	var player_team
	var zone
	var color
	var size
	var gridCoordinate
	var occupied = null
	var label
	var default_color = Color.OLIVE
	var select_component: SelectComponent
	var collider_component
	var _field_color = Color.OLIVE
	var force_label = false
	var rollDisplayComponent: RollDisplayComponent
	signal mouse_exited_field_square(fieldSquare)

	signal mouse_entered_field_square(fieldSquare)

	func color_to_default():
		self.color = self.default_color
		self.queue_redraw()

	func relay_mouse_enter():
		mouse_entered_field_square.emit(self)

	func relay_mouse_exited():
		mouse_exited_field_square.emit(self)

	func _draw():
		draw_rect(
			Rect2(Vector2(-35 / 2, -35 / 2), Vector2(self.size.x - 1, self.size.y - 1)), self.color
		)

	func change_color(color: Color):
		self.color = color
		self.queue_redraw()

	func _init(newPosition, player_team, zone, color, size, gridCoordinate: Vector2):
		self.player_team = player_team
		self.zone = zone
		self.color = color
		self.size = size
		self.square_position = newPosition
		self.gridCoordinate = gridCoordinate
		self.name = "field_square"
		name = "field_square"
		self.position = newPosition + Vector2(35 / 2, 35 / 2)

		input_pickable = true
		monitoring = true
		label = Label.new()
		label.visible = false
		#label.text = str(self.gridCoordinate)
		self.rollDisplayComponent = ComponentFactory.build_roll_display_component()
		self.select_component = ComponentFactory.build_select_component()
		
		self.select_component.ready.connect(on_select_component_ready)

		add_child(self.rollDisplayComponent)
		add_child(self.select_component)

		self.rollDisplayComponent.position += Vector2(size.x / 2 - 3, -size.y / 2 + 3)
		add_child(label)

	func on_select_component_ready():
		var colliderRectangle = RectangleShape2D.new()
		colliderRectangle.set_size(Vector2(33, 33))
		self.select_component.set_shape_collider(colliderRectangle)
		self.select_component.node_emit_on_select = self

	func disable_collision(isDisable: bool):
		self.select_component.collision_component.disabled = !isDisable

	func _get_square_position() -> Vector2:
		return self.square_position

	func _set_square_position(new_square_position: Vector2):
		self.square_position = new_square_position
		self.global_position = new_square_position

	func _get_player_team() -> String:
		return self.player_team

	func _set_player_team(newTeam: String):
		self.player_team = newTeam

	func _get_zone() -> String:
		return self.zone

	func _set_zone(zone: String):
		self.zone = zone

	func _get_color() -> Color:
		return self.color

	func _set_color(newColor: Color):
		self.color = newColor

	func _get_size() -> Vector2:
		return self.size

	func _set_size(newSize: Vector2):
		self.size = newSize

	func activate_label(isActive: bool, text: String = "null"):
		if isActive:
			self.label.visible = true
			self.label.text = text
			return
		if !isActive and !force_label:
			self.label.visible = false
	
	func disable():
		#disable select_component
		self.select_component.disable()
		#disable roll_display_component
		self.rollDisplayComponent.disable()
		#clear occupied state
		self.occupied = null
		



		#var rigidbody = RigidBody2D.new()
		#rigidbody.add_child(colliderShapeObj)
		#rigidbody.global_position = global_position
		#print(rigidbody)
		#rigidbody.input_pickable = true;
		#rigidbody.mouse_entered.connect(on_mouse_entered)
		#add_child(rigidbody)
