extends Node2D

var _bar
var scroll_container:ScrollContainer
var label:Label

func set_scroll_container(scroll_container:ScrollContainer) -> void:
	self.scroll_container = scroll_container
	self.label = self.scroll_container.get_node("Label")
	_bar = scroll_container.get_v_scroll_bar()
	_bar.changed.connect(_go_to_bottom)

func _go_to_bottom() -> void:
	scroll_container.scroll_vertical = _bar.max_value

func add_text(text:String) -> void:

	label.text = label.text + "\n" + text