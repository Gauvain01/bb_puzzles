class_name StatsController
extends HBoxContainer

@export var plus_button: Button
@export var minus_button: Button
@export var stat_label: Label

func set_stat(stat_value: int):
	stat_label.text = str(stat_value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plus_button.pressed.connect(on_plus_button_clicked)
	minus_button.pressed.connect(on_minus_button_clicked)

func get_current_stat_value() -> int:
	return int(stat_label.text)

func on_plus_button_clicked():
	var current_stat = get_current_stat_value()
	current_stat += 1
	set_stat(current_stat)

func on_minus_button_clicked():
	var current_stat = get_current_stat_value()
	current_stat -= 1
	set_stat(current_stat)
