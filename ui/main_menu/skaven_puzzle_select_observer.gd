class_name PuzzleSelector
extends ScrollContainer
@onready var vbox:VBoxContainer = get_node("VBoxContainer")
@onready var team_selector:TeamSelector = %TeamSelector

var puzzle_map :Dictionary = {}


func _ready():
	#subscribe to team_select_signal on TeamSelector
	team_selector.team_selected.connect(on_team_select)

func clear_puzzle_map():
	for child in vbox.get_children():
		child.queue_free()

func load_puzzle_map(team_path):
	pass

func on_team_select(team_path):
	#observe team select button and
	clear_puzzle_map()
	load_puzzle_map(team_path)
	pass


func _on_puzzle_pressed(puzzle_index:int):
	#change scene to selected puzzle
	
	var new_scene = puzzle_map[puzzle_index]
	clear_puzzle_map()
	SceneController.change_scene(new_scene)
	pass