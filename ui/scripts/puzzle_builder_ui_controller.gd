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
@onready var build_button:Button = get_node("BuildButton")
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

func _ready() -> void:
	player_team_drop_down.get_popup().id_pressed.connect(_on_player_team_drop_down_selected)

func _on_player_team_drop_down_selected(id):
	current_selected_player_team = team_id_map[id]
	player_team_selected.emit(team_id_map[id])

func show_build_screen_with_json_data(json_string:String):
	var build_display:Panel = get_node("%BuildDisplayPanel")
	var text_label:TextEdit = build_display.get_node("%BuildTextEdit")
	
	text_label.text = json_string
	build_display.show()

