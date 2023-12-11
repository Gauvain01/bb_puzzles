extends PanelContainer

func _ready():
	LogController.set_scroll_container(get_node("ScrollContainer"))
