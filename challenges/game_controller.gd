extends Control
class_name GameController
@export var  level_name:String ="null"
@export var opponent_placement_allowed:bool = false
@export var field:Field
@export var ui_controller:UiController
@export var victory_observer:VictoryObserver
@export var selection_observer:SelectionObserver

@onready var end_setup_button:Button = ui_controller.end_setup_button
@onready var sideboard:PanelContainer = ui_controller.sideboard
@onready var player_team:TeamComponent = field.player_team

var total_players
var game_state = GAME_STATE.SETUP

signal game_state_changed(game_state)
func _ready():
	total_players = player_team.get_players(); 
	ui_controller.get_end_setup_button_signal().connect(on_end_setup_pressed)
	victory_observer.victory_condition_achieved.connect(on_victory_achieved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_game_state() -> GAME_STATE:
	return game_state
	
func set_game_state(game_state:GAME_STATE):
	self.game_state = game_state


func on_victory_achieved():
	ui_controller.activate_end_game_screen(true)
	game_state = GAME_STATE.COMPLETE
	game_state_changed.emit(GAME_STATE.COMPLETE)
	remove_child(selection_observer)


func on_end_setup_pressed():
	if sideboard.players_on_sideboard != 0:
		
		
		LogController.add_text("ERROR: Not all players from the sideboard are on the field")
		return
	start_game_state_play()

func start_game_state_play():
	game_state = GAME_STATE.PLAY
	game_state_changed.emit(game_state)


