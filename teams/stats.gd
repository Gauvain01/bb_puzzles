class_name PlayerStats
extends Node2D

@export var MA = 0
@export var STR = 0
@export var AG = 0
@export var PA = 0
@export var AV = 0

func to_dict() -> Dictionary:
	return {
		"MA":MA,
		"STR":STR,
		"AG":AG,
		"PA":AG,
		"AV":AV
		}

			
