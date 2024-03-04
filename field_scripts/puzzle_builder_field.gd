class_name PuzzleBuilderField
extends Field

var ui: PuzzleBuilderUiController
@onready var player_loader: PlayerLoader = get_node("PlayerLoader")
@onready var player_side_board_controller: SideBoardController = get_node("SideBoardController")
@onready var player_builder: PlayerBuilder = get_node("PlayerBuilder")

signal refreshed_player_team
signal refreshed_opponent_team
signal spawned_new_player(player)

var opponent_player_pool = {}
var player_team_player_pool = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_parent().get_node("PuzzleBuilderUi")
	super._ready()
	player_builder.set_up_player_builder()
	sideboard = player_side_board_controller
