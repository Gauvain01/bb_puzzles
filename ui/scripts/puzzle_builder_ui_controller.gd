class_name PuzzleBuilderUiController
extends Control

@export var field: Field
@export var selection_observer: SelectionObserver

@onready var player_team_drop_down: MenuButton = get_node("%TeamSelectDropDown")
@onready var player_builder_panel: PlayerBuilderPanel = get_node("%PlayerBuilderPanel")
@onready var puzzle_type_drop_down: MenuButton = get_node("PuzzleTypeMenu")
@onready var puzzle_information_text: TextEdit = get_node("%PuzzleInformationTextEdit")
@onready var puzzle_name_text:TextEdit = get_node("%PuzzleNameTextEdit")
@onready var puzzle_creator_text:TextEdit = get_node("%CreatorNameText")

signal player_team_selected(int)
signal puzzle_type_selected(int)

var current_selected_player_team

var team_id_map = {
	0: TEAM_ENUM.SKAVEN,
	1: TEAM_ENUM.HUMANS
}
var puzzle_id_map = {
0:PUZZLE_TYPE.SCORE,
1:PUZZLE_TYPE.BLOCK,
2:PUZZLE_TYPE.SURF,
3:PUZZLE_TYPE.SCORE,
}

func _on_player_team_drop_down_selected(id):
	current_selected_player_team = team_id_map[id]
	player_team_selected.emit(team_id_map[id])
