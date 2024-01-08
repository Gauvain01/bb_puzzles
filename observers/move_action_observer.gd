extends Node2D
class_name MoveActionObserver

@export var field: Field
@export var ui_controller: UiController
@export var selection_observer: SelectionObserver

@onready var player_team: TeamComponent = field.player_team
@onready var movePopup: Label = ui_controller.move_popup

var active_move_event = null
var current_player:Player = null

func _ready():
	for i in player_team.get_players():
		var player: Player = i
		player.request_move_event.connect(_on_player_team_move_action_triggered)


func _on_player_team_move_action_triggered(player):
	current_player = player
	player_team.set_all_active_players_to_idle_state()
	player.state_machine.switch_state(PLAYER_STATE.ACTIVE_STATE)
	active_move_event = await MoveEventScript.MoveEvent.new(field, player, selection_observer)

	add_child(active_move_event)
	active_move_event.is_completed.connect(on_complete_move_event)
	active_move_event.start()
	movePopup.visible = true


func on_complete_move_event():
	current_player.state_machine.switch_state(PLAYER_STATE.FINISHED_STATE)
	movePopup.visible = false
	
