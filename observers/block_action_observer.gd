class_name BlockActionObserver
extends Node2D

@export var blockDieCalculator: BlockDieCalculator
@export var field: Field

@onready var player_team: TeamComponent = field.player_team
@onready var grid: Node2D = field.grid
@onready var opponent_team: Node2D = field.opponent

var currentBlocker: Player
var currentBlockEvent: BlockEventScript.BlockEvent
var possible_block_event = []
var active_block_event = null
var selected_opponent = null
var possible_block_targets = []
var end_turn_for_player_after_block = true

signal completed_block_event


func get_possible_block_targets(gridPosition):
	var gridCoordinate = gridPosition
	var surroundingGridPositions = [
		Vector2(gridCoordinate.x + 1, gridCoordinate.y + 1),
		Vector2(gridCoordinate.x, gridCoordinate.y + 1),
		Vector2(gridCoordinate.x - 1, gridCoordinate.y + 1),
		Vector2(gridCoordinate.x + 1, gridCoordinate.y),
		Vector2(gridCoordinate.x - 1, gridCoordinate.y),
		Vector2(gridCoordinate.x, gridCoordinate.y - 1),
		Vector2(gridCoordinate.x + 1, gridCoordinate.y - 1),
		Vector2(gridCoordinate.x - 1, gridCoordinate.y - 1)
	]
	var opponents = []
	for field_square in field.get_field_squares_by_grid_positions(surroundingGridPositions):
		if field_square.occupied == null:
			continue
		if field_square.occupied.isOpponent:
			opponents.append(field_square.occupied)
	return opponents


func evaluate_player_has_block_targets(player) -> bool:
	if typeof(player) == TYPE_VECTOR2:
		return len(get_possible_block_targets(player)) > 0
	else:
		return len(get_possible_block_targets(player.my_field_square.gridCoordinate)) > 0


func _ready():
	for i in player_team.get_players():
		var player: Player = i
		player.request_block_event.connect(on_block_request)


func on_block_request(player: Player):
	if !evaluate_player_has_block_targets(player):
		LogController.add_text(
			str(player.name) + " does not base any players, cannot perform the block action"
		)
		return
	player_team.activate_ui_component_all_players(false, player)
	player.change_player_state(PLAYER_STATE.BLOCK_STATE)
	currentBlocker = player
	for j in get_possible_block_targets(player.my_field_square.gridCoordinate):
		var i: Player = j
		i.select_component.selected.connect(on_selected_opponent)
		blockDieCalculator.evaluate_and_show_block_dice(currentBlocker, i)


func on_selected_opponent(player: Player):
	selected_opponent = player

	for i in get_possible_block_targets(currentBlocker.my_field_square.gridCoordinate):
		i.select_component.selected.disconnect(on_selected_opponent)
	on_opponent_selected_during_block()
	for i in get_possible_block_targets(currentBlocker.my_field_square.gridCoordinate):
		var opponent: Player = i

		opponent.blockDiceViewer.activate(false)


func on_block_event_completed():
#	active_block_event.blocker.deactivate()
	active_block_event.destroy()
	remove_child(active_block_event)
	active_block_event = null

	currentBlocker.change_player_state(PLAYER_STATE.FINISHED_STATE)
	player_team.activate_ui_component_all_players(true)
	completed_block_event.emit()
	field.tackle_zone_component.refresh_tackle_zones()


func _on_player_team_block_event(player: Player):
	if active_block_event == null:
		var square: field_square_script.FieldSquare = player.my_field_square
		currentBlocker = player
		possible_block_targets = get_possible_block_targets(square.gridCoordinate)


func on_opponent_selected_during_block():
	var target = selected_opponent
	var blockEvent = BlockEventScript.BlockEvent.new(currentBlocker, target, field)

	add_child(blockEvent)
	blockEvent.start()
	active_block_event = blockEvent
	active_block_event.completed.connect(on_block_event_completed)
	player_team.activate_ui_component_all_players(false)
