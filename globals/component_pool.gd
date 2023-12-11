extends Node


const SELECT_COMPONENT_POOL = []
const INPUT_COMPONENT_POOL = []


func get_select_component() -> SelectComponent:
	var comp = get_component(COMPONENT_TYPE.SELECT_COMPONENT) as SelectComponent
	return comp

func store_select_component(component:SelectComponent) -> void:
	store_component(component, SELECT_COMPONENT_POOL)

func _check_pool_has_item(pool:Array) -> bool:
	if len(pool) == 0:
		return false
	return true

func store_component(component:Node, pool:Array):
	component.disable()
	pool.append(component)

func get_component(component_type:int) -> Node:
	var _pool
	var comp
	
	match component_type:

		COMPONENT_TYPE.SELECT_COMPONENT:
			_pool = SELECT_COMPONENT_POOL
				

		COMPONENT_TYPE.INPUT_COMPONENT:
			_pool = INPUT_COMPONENT_POOL
	
	if _check_pool_has_item(_pool):
		comp = _pool.pop_back()
		comp.enable()
		return comp
	
	comp = ComponentFactory.build_component_by_component_type(component_type)
	comp.enable()
	return comp
				