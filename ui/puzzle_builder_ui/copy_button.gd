extends Button

@onready var build_text:TextEdit = get_node("%BuildTextEdit")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(func(): DisplayServer.clipboard_set(build_text.text))



