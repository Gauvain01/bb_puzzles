extends Node2D
class_name BlockDieCalculator
@export var field:Field



func evaluate_and_get_marking_players(player:Player, check_for_opponent:bool = false, filter_attacker:Player = null, filter_target = null):
	var marks = []
	var directionArr = Util.get_square_direction_vectors()
	for i in directionArr:
		var square:field_square_script.FieldSquare = null
		var coord = player.my_field_square.gridCoordinate + i
		
		if field.is_grid_coordinate_out_of_bounds(coord):
			continue
			
		square = field.get_field_square_by_grid_position(coord)
		if square.occupied == null:
			continue
		var markingPlayer:Player = square.occupied
		
		if filter_attacker == markingPlayer:
			continue
		
		if filter_target == markingPlayer:
			continue

		if check_for_opponent:
			if markingPlayer.isOpponent:
				continue
		else:
			if !markingPlayer.isOpponent:
				continue
		
		marks.append(markingPlayer)
	return marks


func get_player_mark_amount(player:Player, target:Player) -> int:
	
	var isOpponent = player.isOpponent
	
	var marking_players = evaluate_and_get_marking_players(player, isOpponent, player, target)
	var marking_players_to_discard = []
	for i in range(len(marking_players)):
		if len(evaluate_and_get_marking_players(marking_players[i], !isOpponent, player, target)) > 0:
			marking_players_to_discard.append(marking_players[i])
	print("marking players to discard")
	print(marking_players_to_discard)
	return len(marking_players) - len(marking_players_to_discard)


func get_assist_amount(target:Player, filter_player = null):
	var assists = 0
	var target_marks = evaluate_and_get_marking_players(target, true)
	if len(target_marks) > 1:
		for i in target_marks:
			var player:Player = i
			if player == filter_player:
				continue
			if len(evaluate_and_get_marking_players(player)) - 1 == 0:
				assists += 1
	return assists
	

func get_block_dice(blocker:Player, target:Player) -> ENUMS.DICE_ROLL_TYPE:
	var strength_difference = blocker.stats.STR - target.stats.STR
	print("strengt diff base")
	print(strength_difference)
	strength_difference -= get_player_mark_amount(blocker, target)
	print("player mark amount %d" % get_player_mark_amount(blocker, target))
	print(strength_difference)
	strength_difference += get_assist_amount(target, blocker)
	print(strength_difference)
	
	if strength_difference < 0:
		return ENUMS.DICE_ROLL_TYPE.TWO_DIE_AGAINST
	
	if strength_difference > target.stats.STR * 2:
		return ENUMS.DICE_ROLL_TYPE.THREE_DIE_BLOCK
	
	if strength_difference > 0:
		return ENUMS.DICE_ROLL_TYPE.TWO_DIE_BLOCK
	print(strength_difference)
	
	return ENUMS. DICE_ROLL_TYPE.ONE_DIE_BLOCK
	
func evaluate_and_show_block_dice(blocker:Player, target:Player):
	var block_dice:ENUMS.DICE_ROLL_TYPE = get_block_dice(blocker, target)
	match block_dice:
		
		ENUMS.DICE_ROLL_TYPE.ONE_DIE_BLOCK:
			target.blockDiceViewer.activate(true, false, 1)
		ENUMS.DICE_ROLL_TYPE.TWO_DIE_BLOCK:
			target.blockDiceViewer.activate(true, false, 2)
		ENUMS.DICE_ROLL_TYPE.THREE_DIE_BLOCK:
			target.blockDiceViewer.activate(true, false, 3)
		ENUMS.DICE_ROLL_TYPE.TWO_DIE_AGAINST:
			target.blockDiceViewer.activate(true, true, 2)

	
	
	
	
	
	
