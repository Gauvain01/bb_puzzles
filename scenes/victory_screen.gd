extends Panel


func _ready():
	LogController.set_scroll_container(get_node("%ScrollContainer"))

var roll_type_map = {
	ENUMS.DICE_ROLL_TYPE.RUSH:"RUSH",
	ENUMS.DICE_ROLL_TYPE.DODGE:"DODGE",
	ENUMS.DICE_ROLL_TYPE.TWO_DIE_BLOCK:"TWO DIE BLOCK",
	ENUMS.DICE_ROLL_TYPE.ONE_DIE_BLOCK:"ONE DIE BLOCK",
	ENUMS.DICE_ROLL_TYPE.THREE_DIE_BLOCK:"THREE DIE BLOCK",
	ENUMS.DICE_ROLL_TYPE.TWO_DIE_AGAINST:"TWO DIE AGAINST",
	ENUMS.DICE_ROLL_TYPE.THREE_DIE_AGAINST:"THREE DIE AGAINST"
}

func display_dice_log_data_in_dice_log():
	for dice_roll_data:DiceRollData in DiceLog.dice_rolls:
		var print_statement = roll_type_map[dice_roll_data.roll_type]
		LogController.add_text(print_statement)