extends ScrollContainer
@onready var skaven_puzzle_selector:ScrollContainer = get_node("%SkavenPuzzleSelector")

var current_puzzle_container:ScrollContainer = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_puzzle_container(new_puzzle_container:ScrollContainer) -> void:
	if current_puzzle_container != null:
		current_puzzle_container.visible = false
	new_puzzle_container.visible = true
	current_puzzle_container = new_puzzle_container

func _on_skaven_pressed():
	change_puzzle_container(skaven_puzzle_selector)
