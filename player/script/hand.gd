extends Node2D

const state = preload("res://player/script/state.gd")

onready var WEAPON_SLOT = {
	state.Hand.LEFT: null,
	state.Hand.RIGHT: null,
}

onready var ACTIVE_HAND = state.Hand.LEFT
onready var ACTIVE = false
# var FRAME = 0
func _ready():
	var node = load("res://player/attack/Grave Reaver/scene/Main.tscn")
	swap_weapon(state.Hand.RIGHT, node.instance())
	swap_weapon(state.Hand.LEFT, node.instance())	

	
func activate(which_hand, player_dir, player_is, player_action) -> int:
	ACTIVE_HAND = which_hand
	var weapon = WEAPON_SLOT[ACTIVE_HAND]
	if weapon == null:
		return 0
	if ACTIVE:
		return 0
	# if FRAME > 0:
	# 	return 0
	return weapon.activate(which_hand, player_dir, player_is, player_action)

func deactivate():
	ACTIVE = false
	# FRAME = 0			
	_deactivate(state.Hand.RIGHT)
	_deactivate(state.Hand.LEFT)

func _deactivate(hand):
	var weapon = WEAPON_SLOT[hand]
	if weapon != null:
		weapon.deactivate()

func attack(frame):
	# FRAME = frame
	WEAPON_SLOT[ACTIVE_HAND].attack(frame)
	# pass

func swap_weapon(which_hand, weapon):
	remove_child(WEAPON_SLOT[which_hand])
	add_child(weapon)
	WEAPON_SLOT[which_hand] = weapon
