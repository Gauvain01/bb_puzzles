class_name PuzzleBuilderField
extends Field

var ui: PuzzleBuilderUiController
@onready var player_loader: PlayerLoader = get_node("PlayerLoader")
@onready var player_side_board_controller: SideBoardController = get_node("SideBoardController")
@onready var player_builder: PlayerBuilder = get_node("PlayerBuilder")

signal refreshed_player_team(TEAM_ENUM)
signal refreshed_opponent_team(TEAM_ENUM)
signal spawned_new_player(player)

var player_team_type:int
var opponent_team_type:int

var opponent_player_pool = {}
var player_team_player_pool = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_parent().get_node("PuzzleBuilderUi")
	super._ready()
	player_builder.set_up_player_builder()
	sideboard = player_side_board_controller
	_spawn_ball()
	placed_player_on_field.connect(on_player_placed)

func on_player_placed(player:Player):
	var team_type = player.team_type
	if player.isOpponent:
		if opponent_team_type == null:
			opponent_team_type = team_type
			refreshed_opponent_team.emit(team_type)
			return
		else:
			return
	if player_team_type == null:
		player_team_type = team_type
		refreshed_player_team.emit(team_type)
	return
		
func _spawn_ball():
	#load the _ball up
	var new_ball = Ball.new_ball(self)
	add_child(new_ball)
	_ball = new_ball

	#set _ball position
	_ball.position = get_field_map()[Vector2(1, 1)].position
	_ball.set_ball_owner(NodeInspector.get_ball_holdable_component(get_field_map()[Vector2(1,1)]))


