class_name UiController
extends Control

@export var end_game_screen:Panel
@export var sideboard:PanelContainer
@export var move_popup:Label
@export var end_setup_button:Button
@export var player_team_tackle_check_button:CheckButton
@export var opponent_tackle_check_button:CheckButton
@export var field:Field
@export var selection_observer:SelectionObserver


func _ready():
	get_node("PlayerCard").setup(field, selection_observer)
	field.tackle_zone_component.connect_button_signals(opponent_tackle_check_button, player_team_tackle_check_button)
	

func activate_end_game_screen(isActive:bool) -> void:
	end_game_screen.visible = isActive


func get_end_setup_button_signal() -> Signal:
	return end_setup_button.pressed




