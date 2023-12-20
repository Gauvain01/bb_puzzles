extends Control
class_name RollDisplayComponent
@export var label:Label

var dice_roll_map = {}
var disabled_flag:bool = false

func disable():
	disabled_flag = true


func activate(isActive:bool):
	if disabled_flag:
		return
	visible = isActive
	if !isActive:
		if len(dice_roll_map.values()) > 0:
			for i in dice_roll_map.values():
				var foo:Object = i
				foo.free()
		dice_roll_map = {}
func set_label_text(text:String):
	if disabled_flag:
		return
	label.text = text

func add_dice_roll(dice_roll:DiceRollData):
	if disabled_flag:
		return
	if !dice_roll_map.has(dice_roll.roll_type):
		dice_roll_map[dice_roll.roll_type] = dice_roll
		if len(dice_roll_map.values()) == 1:
			set_label_text(str(dice_roll.succes_value) + "+")
		else:
			set_label_text(label.text + "/" +str(dice_roll.succes_value) + "+" )
		print(label.text)
