extends PanelContainer

@onready var label = $Label
@onready var MA_label = $VBoxContainer/MA_label
@onready var ST_label = $VBoxContainer/ST_label
@onready var AG_label = $VBoxContainer/AG_label
@onready var AV_label = $VBoxContainer/AV_label
@onready var PA_label = $VBoxContainer/PA_label
@export var player_team:TeamComponent
@export var selectionObserver:SelectionObserver
@export var opponent:TeamComponent
@export var field:Field
var is_selection = false

func on_board_piece_hover(board_piece):
	if board_piece.isOpponent:
		label.label_settings.font_color = Color.RED
	else:
		label.label_settings.font_color = Color.AQUA
	if !is_selection:
		MA_label.text = "MA:   %d" % board_piece.get_node("Stats").MA
		ST_label.text = "ST:    %d" % board_piece.get_node("Stats").STR
		AG_label.text = "AG:   %d+" % board_piece.get_node("Stats").AG
		PA_label.text = "PA:   %d+" % board_piece.get_node("Stats").PA
		AV_label.text = "AV:   %d+" % board_piece.get_node("Stats").AV
		label.text = board_piece.name

func on_board_piece_exit_hover(_player:Player):
	MA_label.text = "MA:"
	ST_label.text = "ST:" 
	AG_label.text = "AG:" 
	AV_label.text = "AV:" 
	PA_label.text = "PA:"
		
	
func _ready():
	label.label_settings = LabelSettings.new()
	set_player_card_values()
	
func set_player_card_values():
	print("got here player_card")
	for player in player_team.get_players():
		player.select_component._mouse_entered_release_selected.connect(on_board_piece_hover)
		player.select_component._mouse_exited_release_selected.connect(on_board_piece_exit_hover)
		$VBoxContainer/MA_label.text = "MA:"
		$VBoxContainer/ST_label.text = "ST:" 
		$VBoxContainer/AG_label.text = "AG:" 
		$VBoxContainer/AV_label.text = "AV:" 
		$VBoxContainer/PA_label.text = "PA:"
		
		
	selectionObserver.selection_is_on.connect(on_selection_is_on)
	selectionObserver.selection_is_off.connect(on_selection_is_off)
	for board_piece in opponent.get_players():
		board_piece.select_component._mouse_entered_release_selected.connect(on_board_piece_hover)
		board_piece.select_component._mouse_exited_release_selected.connect(on_board_piece_exit_hover)

func on_selection_is_on():
	is_selection = true
func on_selection_is_off():
	is_selection = false

