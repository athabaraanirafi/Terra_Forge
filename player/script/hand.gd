extends Node2D

const weapon = preload("res://weapon/weapon.gd")

var CURRENT_WEAPON

func _ready():
	load_weapon(weapon.ID.Basic_Sword)
	
func load_weapon(weapon_id):
	if CURRENT_WEAPON:
		self.queue_free()	
	CURRENT_WEAPON = load(weapon.LIST[weapon_id].Path).instance()
	self.add_child(CURRENT_WEAPON)

func attack():
	CURRENT_WEAPON.attack()
	pass
