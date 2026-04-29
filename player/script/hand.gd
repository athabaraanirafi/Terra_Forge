extends Node2D

const state = preload("res://player/script/state.gd")

onready var WEAPON_SLOT = {
	state.Hand.LEFT: null,
	state.Hand.RIGHT: null,
}

onready var ACTIVE_HAND = state.Hand.LEFT

func _ready():
	var node = load("res://player/attack/Grave Reaver/scene/Main.tscn")
	WEAPON_SLOT[state.Hand.RIGHT] = node.instance()
	WEAPON_SLOT[state.Hand.LEFT] = node.instance()
	add_child(WEAPON_SLOT[state.Hand.RIGHT])
	add_child(WEAPON_SLOT[state.Hand.LEFT])

	

func activate(which_hand, player_dir, player_is, player_action) -> int:
	ACTIVE_HAND = which_hand
	var weapon = WEAPON_SLOT[ACTIVE_HAND]
	if weapon == null:
		return 1
	return weapon.activate(player_dir, player_is, player_action)

func deactivate():
	WEAPON_SLOT[ACTIVE_HAND].deactivate()

func attack(frame) -> int:
	return WEAPON_SLOT[ACTIVE_HAND].attack(frame)
	pass
