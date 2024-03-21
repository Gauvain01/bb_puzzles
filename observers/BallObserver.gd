class_name BallObserver
extends Node2D

@export var field:Field
var _ball:Ball
var ball_select_component:SelectComponent



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func start_ball_observer():
	_ball = field.get_ball()
	ball_select_component = NodeInspector.get_select_component(_ball)
	if field is PuzzleBuilderField:
		start_listen_for_drag_and_drop()

	

func start_listen_for_drag_and_drop():
	ball_select_component.selected.connect(on_ball_select)

func on_ball_select(ball:Ball):
	ball_select_component.emit_deselected_on_next_mouse_release = true
	ball_select_component.allow_emit_deselected = true
	var dad:DragAndDropComponent = NodeInspector.get_drag_and_drop_component(ball)
	dad.drag()
	ball_select_component.deselected.connect(on_ball_deselect, CONNECT_ONE_SHOT)

func on_ball_deselect(ball:Ball):
	var dad:DragAndDropComponent = NodeInspector.get_drag_and_drop_component(ball)
	dad.drop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
