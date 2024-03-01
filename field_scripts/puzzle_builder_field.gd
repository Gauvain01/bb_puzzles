class_name PuzzleBuilderField
extends Field

var ui: PuzzleBuilderUiController
@onready var player_loader: PlayerLoader = get_node("PlayerLoader")
@onready var PlayerSideBoardController: SideBoardController = get_node("SideBoardController")
@onready var player_builder: PlayerBuilder = get_node("PlayerBuilder")

signal refreshed_player_team
signal refreshed_opponent_team
signal spawned_new_player(player)

var opponent_player_pool = {}
var player_team_player_pool = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_parent().get_node("PuzzleBuilderUi")
	ui.player_team_selected.connect(on_player_team_selected)
	super._ready()
	player_builder.set_up_player_builder()

func on_player_team_selected(team_enum):
	load_players_on_sideboard(player_team, PlayerSideBoardController, false, team_enum, player_team_player_pool, refreshed_player_team)

func load_players_on_sideboard(team: TeamComponent, sideboard_controller: SideBoardController, is_opponent: bool, team_enum: int, collection: Dictionary, refreshment_signal_to_emit: Signal):
	collection.clear()
	team.remove_all_players()
	var player_paths = player_loader.open_team_dir_get_player_path(team_enum)

	for path in player_paths:
		var player: Player = load(path).instantiate() as Player

		collection[player.player_type_string] = {"path": path, "collection":[player]}
		player.isOpponent = is_opponent
		team.add_child(player)

	for player in team.get_players():
		sideboard_controller.request_to_place_on_sideboard(player)
	refreshment_signal_to_emit.emit()

func instantiate_new_player(player_type_string, is_opponent: bool) -> Player:
	if is_opponent:
		var player = load(opponent_player_pool[player_type_string]["path"]).instantiate() as Player
		player.isOpponent = true
		return player
	else:
		var player = load(player_team_player_pool[player_type_string]["path"]).instantiate() as Player
		player.isOpponent = false
		return player

func spawn_new_player_on_sideboard(player_type_string, is_opponent: bool, square: field_square_script.FieldSquare):
	var player: Player = instantiate_new_player(player_type_string, is_opponent)
	
	if is_opponent:
		opponent.add_child(player)
	else:
		player_team.add_child(player)
		PlayerSideBoardController.request_to_place_on_sideboard(player, square)
	player.state_machine.switch_state(PLAYER_STATE.SETUP_STATE)
	spawned_new_player.emit(player)

func setup_spawning_of_players_on_field_placement():
	placed_new_player_on_field.connect(on_placement_of_player_on_field)

func on_placement_of_player_on_field(player: Player, square: field_square_script.FieldSquare):
	print("placed new player")
	spawn_new_player_on_sideboard(player.player_type_string, player.isOpponent, square)
