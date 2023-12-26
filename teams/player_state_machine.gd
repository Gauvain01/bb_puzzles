class_name PlayerStateMachine
extends Node

var current_state:PlayerState = null
var _state_map = null 

##setups state machine and maps the player states to an enum for easy switching
## for example:
## [code] switch_state(PLAYER_STATE.SETUP_STATE) [/code]
func setup_state_machine(player:Player): 

	_state_map = {}
	var setup_state = SetupState.new(player)
	var idle_state = IdleState.new(player)
	var active_state = ActiveState.new(player)
	var in_active_state = InActiveState.new(player)
	var block_state = BlockState.new(player)
	var blitz_state = BlitzState.new(player)

	_state_map[PLAYER_STATE.SETUP_STATE] = setup_state
	_state_map[PLAYER_STATE.ACTIVE_STATE] = active_state
	_state_map[PLAYER_STATE.INACTIVE_STATE] = in_active_state
	_state_map[PLAYER_STATE.IDLE_STATE] = idle_state
	_state_map[PLAYER_STATE.BLOCK_STATE] = block_state
	_state_map[PLAYER_STATE.BLITZ_STATE] = blitz_state

## [param new_state]:[enum PLAYER_STATE].[Br]
## make sure [code]setup_state_machine(Player)[/code] is called at least once before this.
func switch_state(new_state:int):
	if current_state != null:
		current_state.exit()
	current_state = _state_map[new_state]
	current_state.enter()

class PlayerState extends Node:
	var _player:Player

	func enter():
		pass
	
	func exit():
		pass
	
	func _init(player:Player):
		_player = player

class SetupState extends PlayerState:
	
	func enter():
		#setup select color
		_player.setup_select_color_activation()
		#setup hover color
		_player.setup_hover_color_activation()
	
	func exit():
		#stop select color
		
		#stop hover color
		pass
	
class ActiveState extends PlayerState:

	func enter():
		#setup select color
		#setup hover color
		#setup stats on hover
		#setup player menu for active state
		pass
	
	func exit():
		#stop select color
		#stop hover color
		#stop stats on hover
		#stop player menu and dissasemble
		pass

class IdleState extends PlayerState:

	func enter():
		#setupt stats on hover
		pass
	func exit():
		#stop stats on hover
		pass

class InActiveState extends PlayerState:

	func enter():
		#set color to inactive
		pass
	func exit():
		#set color to default
		pass
	
class BlitzState extends PlayerState:
	func enter():
		#set color to blitz 
		pass
	
	func exit():
		#set color to default
		pass

class BlockState extends PlayerState:
	func enter():
		#set color to block
		pass

	func exit():
		#set color to default
		pass


	

	

		
