extends Node

var dice_rolls = []

func _ready():
	SceneController.changed_scene.connect(on_scene_changed)

func add_test_dice_roll(dice: int, dice_type: int, amount: int = 1):
	for i in range(amount):
		var dice_roll_data: DiceRollData = preload("res://globals/dice_roll_data.gd").new(
			dice, dice_type
		)
		dice_rolls.append(dice_roll_data)

func on_scene_changed(_old_scene:int, new_scene:int):
	if new_scene != SCENE.VICTORY_SCREEN:
		dice_rolls = []


