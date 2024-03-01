class_name PlayerBuilderPanel
extends PanelContainer
@export var ma_stat_controller: StatsController
@export var av_stat_controller: StatsController
@export var st_stat_controller: StatsController
@export var ag_stat_controller: StatsController
@export var pa_stat_controller: StatsController
@export var team_select_dropdown: TeamSelectDropDown
@export var player_select_dropdown: PlayerSelectDropDown
@export var place_holder_player: TextureRect
@export var is_opponent_check_button: CheckButton
@export var block_check_button: CheckButton
@export var guard_check_button: CheckButton
@export var ball_check_button: CheckButton
@export var frenzy_check_button: CheckButton
@export var clear_button: Button

func clear():
	block_check_button.button_pressed = false
	guard_check_button.button_pressed = false
	ball_check_button.button_pressed = false
	frenzy_check_button.button_pressed = false
