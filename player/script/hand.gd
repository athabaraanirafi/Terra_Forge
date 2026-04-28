extends Node2D

const state = preload("res://player/script/state.gd")

var WEAPON_SLOT = {
	state.Hand.LEFT: null,
	state.Hand.RIGHT: null,
}

var ACTIVE_HAND = state.Hand.LEFT

func activate(which_hand, player_dir, player_is, player_action) -> int:
	ACTIVE_HAND = which_hand
	return WEAPON_SLOT[ACTIVE_HAND].activate(player_dir, player_is, player_action)

func deactivate():
	WEAPON_SLOT[ACTIVE_HAND].deactivate()

func attack(frame) -> int:
	return WEAPON_SLOT[ACTIVE_HAND].attack(frame)
	pass
