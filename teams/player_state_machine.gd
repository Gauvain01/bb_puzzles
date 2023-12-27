class_name PlayerStateMachine
extends Node

var current_state:PlayerState = null
var _state_map = null

signal switched_states(new_state_enum)

##setups state machine and maps the player states to an enum for easy switching
## for example:
## [code] switch_state(PLAYER_STATE.SETUP_STATE) [/code]
func setup_state_machine(player:Player): 

	_state_map = {}
	var setup_state = SetupState.new(player)
	add_child(setup_state)
	var idle_state = IdleState.new(player)
	add_child(idle_state)
	var active_state = ActiveState.new(player)
	add_child(active_state)
	var finished_state = FinishedState.new(player)
	add_child(finished_state)
	var block_state = BlockState.new(player)
	add_child(block_state)
	var blitz_state = BlitzState.new(player)
	add_child(blitz_state)
	var move_state = MoveState.new(player)
	add_child(move_state)

	_state_map[PLAYER_STATE.MOVE_STATE] = move_state
	_state_map[PLAYER_STATE.SETUP_STATE] = setup_state
	_state_map[PLAYER_STATE.ACTIVE_STATE] = active_state
	_state_map[PLAYER_STATE.FINISHED_STATE] = finished_state
	_state_map[PLAYER_STATE.IDLE_STATE] = idle_state
	_state_map[PLAYER_STATE.BLOCK_STATE] = block_state
	_state_map[PLAYER_STATE.BLITZ_STATE] = blitz_state

## [param new_state]:[enum PLAYER_STATE].[Br]
## make sure [code]setup_state_machine(Player)[/code] is called at least once before this.
## for example: [code]switch_state(PLAYER_STATE.SETUP_STATE)[/code]
func switch_state(new_state:int):
	if current_state != null:
		current_state.exit()
	current_state = _state_map[new_state]
	current_state.enter()
	switched_states.emit(new_state)

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
		_player.stop_select_color_activation()
		#stop hover color
		_player.stop_hover_color_activation()

		_player.change_color(_player.default_color)
	
class ActiveState extends PlayerState:

	func enter():
		#setup select color
		_player.setup_select_color_activation()
		#setup hover color
		_player.setup_hover_color_activation()
		#setup player menu for active state
		_player.setup_action_menu_for_activation()
	
	func exit():
		#stop select color
		_player.stop_select_color_activation()
		#stop hover color
		_player.stop_hover_color_activation()
		#deactivate player menu
		_player.deactivate_action_menu()

class IdleState extends PlayerState:

	func enter():
		#setup hover color
		_player.setup_hover_color_activation()
	func exit():
		#stop hover color
		_player.stop_hover_color_activation()
	
class FinishedState extends PlayerState:

	func enter():
		_player.change_color(Color.GRAY)
		_player.deactivated_player.emit(_player)
		_player.isActive = false
		#set color to inactive
	func exit():
		#throw error(kinda thanks gdscript)
		assert(false, "tried to exit the inactive state, when a player is inactive it is not supposed to be activated")

class BlitzState extends PlayerState:
	func enter():
		#set color to blitz 
		_player.change_color(_player.blitz_color)
	
	func exit():
		#set color to default
		_player.change_color(_player.default_color)

class BlockState extends PlayerState:
	func enter():
		#set color to block
		_player.change_color(_player.block_color)

	func exit():
		#set color to default
		_player.change_color(_player.default_color)

class MoveState extends PlayerState:
	func enter():
		_player.setup_select_color_activation()
	
	func exit():
		_player.stop_select_color_activation()
	
	

	

		
