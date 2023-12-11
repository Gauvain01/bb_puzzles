class_name BlitzActionObserver
extends Node2D

@export var field:Field
@export var selectionObserver:SelectionObserver
@export var blockDieCalculator:BlockDieCalculator

@onready var player_team:TeamComponent = field.player_team
@onready var opponent_team:TeamComponent = field.opponent


var active_player:Player = null
var active_target:Player = null
var active_move_event = null
var active_block_event = null
# Called when the node enters the scene tree for the first time.
func _ready():
	for player in player_team.get_players():
		player.request_blitz_event.connect(on_blitz_pressed)


func on_blitz_pressed(player:Player):
	print("blitz pressed")
	player_team.activate_ui_component_all_players(false, player)
	active_player = player
	for i in opponent_team.get_players():
		i.select_component.selected.connect(on_player_select_for_blitz_target)
	opponent_team.change_color_all_players(Color.ORANGE)
	
	
func on_player_select_for_blitz_target(player:Player):
	opponent_team.change_color_all_players(Color.WHITE)

	for i in opponent_team.get_players():
		i.select_component.selected.disconnect(on_player_select_for_blitz_target)
	active_target = player
	
	var move_event = MoveEventScript.BlitzMoveEvent.new(field, active_player, selectionObserver)
	
	add_child(move_event)
	move_event.is_completed.connect(on_movement_event_completed, CONNECT_ONE_SHOT)
	active_move_event = move_event
	move_event.start()

func on_movement_event_completed():
	var marked_players = blockDieCalculator.evaluate_and_get_marking_players(active_player)
	for i in marked_players:
		
		
		if i == active_target:
			listen_for_click_on_active_target()
	
func listen_for_click_on_active_target():
	blockDieCalculator.evaluate_and_show_block_dice(active_player, active_target)
	active_target.select_component.selected.connect(on_select_when_active_player_adjacent_to_target, CONNECT_ONE_SHOT)


func on_select_when_active_player_adjacent_to_target(_redundant):
	start_block_event()
	
func start_block_event():
	active_target.blockDiceViewer.activate(false)
	active_block_event = BlockEventScript.BlockEvent.new(active_player, active_target, field)
	active_block_event.completed.connect(on_block_event_completed)
	add_child(active_block_event)
	active_block_event.start()
	
func on_block_event_completed():
	active_player = null
	active_target = null
	active_move_event.restart()
	active_move_event = null
	active_block_event.destroy()
	active_block_event = null
	field.tackle_zone_component.refresh_tackle_zones()
	field.player_team.activate_ui_component_all_players(true)
