extends Node2D

const state = preload("res://player/script/state.gd")
const sig = preload("res://player/attack/sig-def.gd")
const FRAME = 30
var HIT = 0
# this is temporary. you can create a logic to parse the given state provided by the caller
# to determine which sprite node to call
onready var SPRITE = null
onready var HIT_BOX = null
onready var HAND = 0
func _deactivate():
	SPRITE.hide()
	HIT_BOX.monitoring = false

func _activate():
	SPRITE.show()
	HIT_BOX.monitoring = true

func _ready():
	_pick_frame(0,0)
	_deactivate()
	pass


func _pick_frame(player_is, player_action):
	# Temporary animation because there's currently only one
	SPRITE = $DefaultAttack
	HIT_BOX = $DefaultAttack/HitBox
	
func activate(which_hand, player_dir, player_is, player_action) -> int:
	HIT = 1
	HAND = which_hand
	_pick_frame(player_is, player_action)
	match player_dir:
		state.Dir.LEFT:
			self.scale.x = 1
			# SPRITE.flip_h = false
		state.Dir.RIGHT:
			self.scale.x = -1
			# SPRITE.flip_h = true
	_activate()
	# SPRITE.show()
	return FRAME

func deactivate():
	HIT = 0
	_deactivate()
	# _set_activation_state(false)

func attack(frame):
	# print(frame)
	# if frame > 1:
	_active_frame(frame)
	# 	return HAND
	if frame <= 0:
	# 	SPRITE.hide()
		SPRITE.frame = 0
	# return HAND

func _active_frame(frame):
	# print(frame)

	SPRITE.play("DEFAULT_ATTACK")

func _hit_something(body):
	# print(body)	
	body.emit_signal(sig.DEAL_DAMAGE, 0)
	body.emit_signal(sig.DEAL_PUSH_BACK, Vector2(10, 0))
	body.emit_signal(sig.DEAL_STUN,20)

	pass 
