class_name PuzzleBuilderUiController
extends Control

@export var field: Field
@export var selection_observer: SelectionObserver

@onready var player_team_drop_down: MenuButton = get_node("%TeamSelectDropDown")
@onready var player_builder_panel: PlayerBuilderPanel = get_node("%PlayerBuilderPanel")
@onready var puzzle_type_drop_down: MenuButton = get_node("PuzzleTypeMenu")
@onready var puzzle_information_text: TextEdit = get_node("%PuzzleInformationTextEdit")
signal player_team_selected(int)

var current_selected_player_team

var team_id_map = {
	0: TEAM_ENUM.SKAVEN,
	1: TEAM_ENUM.HUMANS
}

func _ready():
	player_team_drop_down.get_popup().id_pressed.connect(_on_player_team_drop_down_selected)

func _on_player_team_drop_down_selected(id):
	current_selected_player_team = team_id_map[id]
	player_team_selected.emit(team_id_map[id])
