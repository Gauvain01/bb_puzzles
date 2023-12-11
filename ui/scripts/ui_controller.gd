class_name UiController
extends Control

@export var end_game_screen:Panel
@export var sideboard:PanelContainer
@export var move_popup:Label
@export var end_setup_button:Button
@export var player_team_tackle_check_button:CheckButton
@export var opponent_tackle_check_button:CheckButton




func activate_end_game_screen(isActive:bool) -> void:
	end_game_screen.visible = isActive


func get_end_setup_button_signal() -> Signal:
	return end_setup_button.pressed




